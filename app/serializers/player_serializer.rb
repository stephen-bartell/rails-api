# == Schema Information
#
# Table name: players
#
#  id            :uuid             not null, primary key
#  team_id       :uuid
#  slack_id      :string
#  name          :string
#  real_name     :string
#  email         :string
#  password_salt :string
#  password_hash :string
#  points        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class PlayerSerializer < ActiveModel::Serializer

  attributes :id,
    :slack_id,
    :name,
    :real_name,
    :email,
    :points


end
