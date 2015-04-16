class Team < ActiveRecord::Base

  has_many :players
  has_many :scrums
  has_many :entries

  before_validation(on: :create) do
    self.auth_token = SecureRandom.hex
  end

  def current_scrum
    scrums.find_or_create_by(date: Date.today)
  end

end
