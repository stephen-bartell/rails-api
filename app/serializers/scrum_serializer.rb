# == Schema Information
#
# Table name: scrums
#
#  id         :uuid             not null, primary key
#  team_id    :uuid
#  date       :date
#  points     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ScrumSerializer < ActiveModel::Serializer

  attributes :id, :date, :points, :players

  def players
    object.serialized_players
  end

end
