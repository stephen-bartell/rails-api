class ScheduleEventWorker
  include Sidekiq::Worker

  def perform(team_id, event_name)
    return if cancelled?

    puts team_id
    puts event_name
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

end

