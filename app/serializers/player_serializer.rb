class PlayerSerializer < ActiveModel::Serializer

  attributes :id,
    :slack_id,
    :name,
    :real_name,
    :email,
    :points


end
