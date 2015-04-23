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

  # after_save :update_event_schedule

  before_validation(on: :create) do
    self.auth_token = SecureRandom.hex
  end

  def current_scrum
    scrums.find_or_create_by(date: Date.today)
  end

  def send_to_slack_client(data)
    uri = URI(bot_url)
    http = Net::HTTP.new(uri.host)
    # http.use_ssl = true

    request = Net::HTTP::Post.new('/hubot/astroscrum/team', {'Content-Type' =>'application/json'})
    request.body = data.to_json

    response = http.request(request)
  end

  def prompt
  end

  def reminder
  end

  def summary
  end

  def next_run_for_event(event_name)
    crontab = self["#{event_name}_at"]
    cron = CronParser.new(crontab)
    cron.next(Time.now + 10.seconds)
  end

  def queue_event(event_name)
    run_at = next_run_for_event(event_name)
    jid = ScheduleEventWorker.perform_at(run_at, id, event_name)
    update_column("#{event_name}_jid".to_sym, jid)
  end

  def unqueue_event(event_name)
    job_id = self["#{event_name}_jid"]
    queue = Sidekiq::Queue.new
    queue.each do |job|
      job.delete if job.jid == job_id
    end
  end

end
