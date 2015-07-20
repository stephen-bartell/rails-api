# == Schema Information
#
# Table name: jobs
#
#  id                   :integer          not null, primary key
#  jid                  :string
#  method_string        :string           not null
#  reoccurrence_crontab :string
#  run_at               :datetime
#  run_count            :integer          default(1)
#  status               :string
#  resource_id          :uuid
#  resource_type        :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Job < ActiveRecord::Base

  after_commit -> { self.queue }
  after_destroy -> { self.unqueue }

  # Jobs need to do something, careful, this gets eval'd
  validates :method_string, presence: true

  scope :created,  -> { where(status: 'created') }
  scope :running,  -> { where(status: 'running') }
  scope :finished, -> { where(status: 'finished') }
  scope :canceled, -> { where(status: 'canceled') }
  scope :requeued, -> { where(status: 'requeued') }

  # Run the run in method_string, this can be improved, it should
  # work something like Sidekiq's perform method, where sending in
  # marshalled objects is discouraged.
  def run
    return if run_count == 0

    begin
      eval method_string

      if run_count.zero?
        update_column :status, 'finished'
      else
        update_column :run_count, self.run_count -= 1
        update_column :status, 'requeued'
      end
    rescue
      update_column :status, 'failed'
    end
  end

  # Cancel and unqueue this job, does not delete it. It's not reccomended that
  # are deleted, canceling provided a better papertrail.
  def cancel!

    # Quickly insert a cancel key so that any jobs that may have already
    # booted a worker won't run any code, see ScheduleJobWorker#perform
    ScheduleJobWorker.cancel! jid

    # delete the key in redis
    unqueue

    # set to canceled
    update_column :status, 'canceled'
  end

  # parses the crontab-like attribute `reoccurrence_crontab` and gets the next
  # time that this job should run.
  def next_run_at
    cron = CronParser.new(reoccurrence_crontab)
    run_at = cron.next(Time.now)
  end

  def update_next_run_at
    if reoccurrence_crontab
      update_column :run_at, next_run_at
    end
  end

  def queue
    update_column :status, 'created'

    update_next_run_at

    # Since this runs `after_commit` now, we need to unqueue and requeue
    # the job anytime it's touched.
    unqueue

    if run_at && run_at > Time.now
      jid = ScheduleJobWorker.perform_at(next_run_at, id, method_string)
    else
      jid = ScheduleJobWorker.perform_async(id, method_string)
    end

    update_column :jid, jid
  end

  # TODO: dry this up with below
  def unqueue
    queue = Sidekiq::ScheduledSet.new
    queue.each do |job|
      job.delete if job.jid == jid
    end
  end

  def reoccurs?
    reoccurrence_crontab.present? && run_count > 0
  end

end
