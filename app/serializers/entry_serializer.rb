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

class EntrySerializer < ActiveModel::Serializer

  attributes :id,
    :category,
    :body,
    :points

end
