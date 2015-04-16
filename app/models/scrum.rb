class Scrum < ActiveRecord::Base

  belongs_to :team
  has_many :entries
  has_many :players, through: :entries

  scope :today, -> { where(date: Date.today) }

end
