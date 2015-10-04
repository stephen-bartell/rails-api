class AddDoNotDisturbDaysToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :do_not_disturb_days, :text, array: true, default: [6, 7]
  end
end
