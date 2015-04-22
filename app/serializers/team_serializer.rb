class TeamSerializer < ActiveModel::Serializer

  attributes :id, :name, :points, :slack_id

end
