class ScheduleEventWorker
  include Sidekiq::Worker

  def perform(team_id, event_name)

    # Check if the job is cancelled first
    return if cancelled?

    # Find team
    team = Team.find team_id
    return if team.deliver_notifications?

    # run method, ie, team.prompt
    team.send(event_name)

    # Requeue event
    team.queue_event(event_name)

  end

  # Check to see if there is a cancelled-jid key for this job
  def cancelled?
    Sidekiq.redis { |c| c.exists("cancelled-#{jid}") }
  end

  # Set a cancelled key so that the job won't execute anything when run
  def self.cancel!(jid)
    Sidekiq.redis { |c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

  # Is this event on a do not do_not_disturb_day?
  def do_not_disturb_day?
    ActiveSupport::TimeZone.new(team.timezone).now.wday
  end

end
