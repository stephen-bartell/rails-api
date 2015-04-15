class TeamSerializer < ActiveModel::Serializer

  attributes :id, :name, :points, :slack_id

  # has_many :players
  # has_many :scrums

end
