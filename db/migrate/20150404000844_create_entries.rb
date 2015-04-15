class CreateEntries < ActiveRecord::Migration
  def change

    create_table :entries, id: :uuid do |t|
      t.uuid :team_id
      t.uuid :player_id
      t.uuid :scrum_id

      t.string :category
      t.text :body
      t.integer :points

      t.timestamps null: false
    end

  end
end
