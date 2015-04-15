class Team < ActiveRecord::Base

  has_many :players
  has_many :scrums

  before_validation(on: :create) do
    self.auth_token = SecureRandom.hex
  end

end
