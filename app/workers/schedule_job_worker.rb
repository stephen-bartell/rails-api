class ScheduleJobWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(id, method_string)

    # Check if the job is cancelled first
    return if cancelled?

    # Find job
    job = Job.find id

    # Update status
    job.update_column(:status, 'running')

    # run method with args
    job.run

    # Requeue event
    if job.reoccurs?
      job.queue
      job.update_column(:status, 'requeued')
    else
      job.update_column(:status, 'finished')
    end

    # TODO: publish seralized job here?

  end

  # Check to see if there is a cancelled-jid key for this job
  def cancelled?
    Sidekiq.redis { |c| c.exists("cancelled-#{jid}") }
  end

  # Set a cancelled key so that the job won't execute anything when run
  def self.cancel!(jid)
    Sidekiq.redis { |c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

end

