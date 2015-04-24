class ScheduleEventWorker
  include Sidekiq::Worker

  def perform(team_id, event_name)
    return if cancelled?

    # Find team
    team = Team.find team_id

    # run method, ie, team.prompt
    team.send(event_name)

    # Requeue event
    team.queue_event(event_name)
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

end

