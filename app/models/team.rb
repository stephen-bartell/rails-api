# == Schema Information
#
# Table name: teams
#
#  id          :uuid             not null, primary key
#  name        :string
#  auth_token  :string
#  points      :integer          default(0)
#  slack_id    :string
#  bot_url     :string
#  prompt_at   :string
#  prompt_jid  :string
#  remind_at   :string
#  remind_jid  :string
#  summary_at  :string
#  summary_jid :string
#  timezone    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'sidekiq/api'

class Team < ActiveRecord::Base

  has_many :players
  has_many :scrums
  has_many :entries

  after_save :queue_events

  before_validation(on: :create) do
    self.auth_token = SecureRandom.hex
  end

  def current_scrum
    scrums.find_or_create_by(date: Date.today)
  end

  def send_to_slack_client(data, path)
    uri = URI(bot_url)
    http = Net::HTTP.new(uri.host)

    request = Net::HTTP::Post.new(path, {'Content-Type' =>'application/json'})

    if data.class == ActiveModel::ArraySerializer
      request.body = data.as_json
    else
      request.body = data.to_json
    end

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

  def message(players, data = {}, template)
    data = {
      players: players,
      data: data,
      template: template
    }

    send_to_slack_client(data, '/hubot/astroscrum/message')
  end

  def prompt
    template_path = Rails.root.join('lib/messages/prompt.text')
    message(players.map(&:slack_id), { name: name }, File.read(template_path))
  end

  def reminder
    # TODO: just get the players who have not done their scrum
    players = players.map(&:slack_id)

    template_path = Rails.root.join('lib/messages/reminder.text')
    message(players, { name: name }, File.read(reminder_path))
  end

  def summary
    # send emails
    current_scrum.deliver_summary_email

    # message players
    # TODO: should take an array of channels
    scrum = ActiveModel::ArraySerializer.new([team.current_scrum])

    template_path = Rails.root.join('lib/messages/summary.text')
    announce("general", scrum, File.read(template_path))
  end

  def next_run_for_event(event_name)
    crontab = self["#{event_name}_at"]
    cron = CronParser.new(crontab)
    run_at = cron.next(ActiveSupport::TimeZone.new(timezone).local_to_utc(Time.now) + 10.seconds)
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

end
