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

  scope :current, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }

  before_save :set_points

  def update_player
    scrum.team.prompt_at
  end

end
