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

class Player < ActiveRecord::Base

  belongs_to :team
  has_many :entries
  has_many :scrums, through: :entries

  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :name

  validates_uniqueness_of :email
  validates_uniqueness_of :slack_id

  def self.authenticate(email, password)
    player = find_by_email(email)
    if player && player.password_hash == BCrypt::Engine.hash_secret(password, player.password_salt)
      player
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def scrum
    team.current_scrum
  end

  def display_name
    name || real_name
  end

  def summary
    "<li>" +
     "#{display_name}" +
    "</li>"
  end
end
