# == Schema Information
#
# Table name: jobs
#
#  id                   :integer          not null, primary key
#  jid                  :string
#  method_string        :string
#  reoccurrence_crontab :string
#  run_at               :datetime
#  run_count            :integer
#  status               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Job < ActiveRecord::Base

  after_commit -> { self.queue }
  after_destroy -> { self.unqueue }

  validates :method_string, presence: true

  scope :created,  -> { where(status: 'created') }
  scope :running,  -> { where(status: 'running') }
  scope :finished, -> { where(status: 'finished') }
  scope :canceled, -> { where(status: 'canceled') }
  scope :requeued, -> { where(status: 'requeued') }

  def run
    return if run_count == 0

    begin
      send method_string
      update_column(:run_count, self.run_count -= 1) if run_count.present?
    rescue
      update_column :status, 'failed'
    end
  end

  def cancel!

    # Quickly insert a cancel key so that any jobs that may have already
    # booted a worker won't run any code, see ScheduleJobWorker#perform
    ScheduleJobWorker.cancel! jid

    # delete the key in redis
    unqueue

    # set to canceled
    update_column :status, 'canceled'
  end

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
    # cancel!

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
