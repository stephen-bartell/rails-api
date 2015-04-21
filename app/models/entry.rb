class Entry < ActiveRecord::Base

  belongs_to :player
  belongs_to :scrum

  scope :current, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }

end
