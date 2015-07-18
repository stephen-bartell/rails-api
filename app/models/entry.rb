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

  after_create :tally

  def category=(category)
    write_attribute(:category, category.downcase)
  end

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
    entry_for_today = scrum.entries.where(player_id: player_id, category: "today").count > 1
    entry_for_yesterday = scrum.entries.where(player_id: player_id, category: "yesterday").count > 1

    if created_at > scrum.entries_allowed_after && created_at < scrum.entries_due_at
      if !entry_for_today && category == "today"
        update_column :points, 5
      end

      if !entry_for_yesterday && category == "yesterday"
        update_column :points, 5
      end
    end

    player.tally
    scrum.tally
    scrum.team.tally

    self.points
  end

end
