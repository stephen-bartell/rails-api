class AddNotificationsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :notifications, :boolean, default: true
  end
end
