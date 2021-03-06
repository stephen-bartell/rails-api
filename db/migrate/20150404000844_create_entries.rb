class CreateEntries < ActiveRecord::Migration
  def change

    create_table :entries, id: :uuid do |t|
      t.uuid :player_id
      t.uuid :scrum_id

      t.string :category
      t.text :body
      t.integer :points, default: 0

      t.timestamps null: false
    end

  end
end
