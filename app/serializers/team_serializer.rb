class TeamSerializer < ActiveModel::Serializer

  attributes :id, :name, :auth_token

  has_many :players
  has_many :scrums

end
