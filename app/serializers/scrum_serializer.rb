class ScrumSerializer < ActiveModel::Serializer

  attributes :id, :date, :points, :players

  def players
    object.serialized_players
  end

end
