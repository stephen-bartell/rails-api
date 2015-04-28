# == Schema Information
#
# Table name: entries
#
#  id         :uuid             not null, primary key
#  player_id  :uuid
#  scrum_id   :uuid
#  category   :string
#  body       :text
#  points     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Entry < ActiveRecord::Base

  belongs_to :player
  belongs_to :scrum

  before_save :tally
  after_destroy -> { self.scrum.tally }

  def self.deletable
    where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
  end

  def self.destroy_by_category_for_player(slack_id, category_name)
    player = Player.find_by_slack_id slack_id

    raise "Cannot delete entries without player `slack_id`" unless player

    if category_name
      entries = player.team.current_scrum.entries.where(player_id: player.id, category: category_name)
    else
      entries = player.team.current_scrum.entries.where(player_id: player.id)
    end

    entries = entries.destroy_all
    entries
  end

  def tally
    cron = CronParser.new(scrum.team.summary_at)
    entries_due_at = cron.last(Time.now)

    if created_at < ActiveSupport::TimeZone.new(scrum.team.timezone).local_to_utc(entries_due_at)
      write_attribute :points, 5
    end

    scrum.tally
  end
end
