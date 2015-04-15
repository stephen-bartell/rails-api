class CreateTeams < ActiveRecord::Migration
  def change

    create_table :teams, id: :uuid do |t|
      t.string :name
      t.string :auth_token
      t.integer :points, default: 0
      t.string :slack_id
      t.timestamps null: false
    end

  end
end
