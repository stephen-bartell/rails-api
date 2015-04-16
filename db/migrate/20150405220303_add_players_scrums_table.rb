class AddPlayersScrumsTable < ActiveRecord::Migration
  def change
    create_table :players_scrums do |t|
      t.uuid :player_id
      t.uuid :scrum_id
      t.timestamps
    end
  end
end
