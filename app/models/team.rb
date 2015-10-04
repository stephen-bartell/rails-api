# == Schema Information
#
# Table name: teams
#
#  id                  :uuid             not null, primary key
#  name                :string
#  auth_token          :string
#  points              :integer          default(0)
#  slack_id            :string
#  bot_url             :string
#  prompt_at           :string
#  prompt_jid          :string
#  remind_at           :string
#  remind_jid          :string
#  summary_at          :string
#  summary_jid         :string
#  timezone            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  do_not_disturb_days :text             default(["6", "7"]), is an Array
#

require 'sidekiq/api'

class Team < ActiveRecord::Base

  has_many :players
  has_many :scrums
  has_many :entries
  has_many :jobs, as: :resource

  after_save :queue_events

  before_validation(on: :create) do
    self.auth_token = SecureRandom.hex
  end

  def tally
    update_column :points, scrums.sum(:points)
  end

  def current_scrum
    today = Time.now.in_time_zone(timezone).to_date
    scrums.where(date: today, team_id: id).first_or_create
  end

  def send_to_slack_client(data, path)
    uri = URI(bot_url)
    http = Net::HTTP.new(uri.host)

    request = Net::HTTP::Post.new(path, {'Content-Type' =>'application/json'})
    request.body = data.to_json

    puts "request =============================="
    puts request.body

    response = http.request(request)
  end

  def announce(channel = 'general', data = {}, template)
    data = {
      channel: channel,
      data: data,
      template: template
    }

    send_to_slack_client(data, '/hubot/astroscrum/announce')
  end

  ##
  # Send message to every player, excluding ones that have notifications disabled
  def message(players, data = {}, template)

    puts "players ==========================="
    puts self.players

    puts "players.where(notifications: false).map(&:slack_id) ==========================="
    puts self.players.where(notifications: false).map(&:slack_id)

    data = {
      players: players - self.players.where(notifications: false).map(&:slack_id),
      data: data,
      template: template
    }

    send_to_slack_client(data, '/hubot/astroscrum/message')
  end

  def prompt
    template_path = Rails.root.join('lib/messages/prompt.text')
    message(players.map(&:slack_id), { name: name }, File.read(template_path))
  end

  def remind
    template_path = Rails.root.join('lib/messages/reminder.text')

    players_to_remind = []
    players.each do |player|
      entries = Entry.where(player_id: player.id, scrum_id: current_scrum.id, category: ['today', 'yesterday'])
      if entries.size == 0
        players_to_remind << player
      end
    end

    if players_to_remind.size > 0
      message(players_to_remind.map(&:slack_id), { name: name }, File.read(template_path))
    end
  end

  def announce_summary
    if current_scrum.players.size > 0
      template_path = Rails.root.join('lib/messages/summary.text')
      announce("general", current_scrum.summary_attrs, File.read(template_path))
    else
      template_path = Rails.root.join('lib/messages/summary_for_failed_scrum.text')
      announce("general", current_scrum.summary_attrs, File.read(template_path))
    end
  end

  def summary
    # Deliver email to team with summary
    current_scrum.deliver_summary_email

    # Announce summary via Slack
    announce_summary
  end

  def next_run_for_event(event_name)
    crontab = self["#{event_name}_at"]
    cron = CronParser.new(crontab)

    local_time = ActiveSupport::TimeZone.new(timezone).now + 10.seconds
    run_at = cron.next(local_time)

    ActiveSupport::TimeZone.new(timezone).local_to_utc(run_at)
  end

  def queue_event(event_name)
    unqueue_event(event_name)
    run_at = next_run_for_event(event_name)
    jid = ScheduleEventWorker.perform_at(run_at, id, event_name)
    update_column("#{event_name}_jid".to_sym, jid)
  end

  def unqueue_event(event_name)
    job_id = self["#{event_name}_jid"]
    queue = Sidekiq::ScheduledSet.new
    queue.each do |job|
      job.delete if job.jid == job_id
    end
  end

  def queue_events
    ['prompt', 'remind', 'summary'].each do |event_name|
      queue_event(event_name)
    end
  end

  def unqueue_events
    ['prompt', 'remind', 'summary'].each do |event_name|
      unqueue_event(event_name)
    end
  end

  def deliver_notifications?
    Date.today.wday.in? team.do_not_disturb_days.map(&:to_i)
  end

end
