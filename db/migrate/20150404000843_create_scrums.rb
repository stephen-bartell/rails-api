class CreateScrums < ActiveRecord::Migration
  def change

    create_table :scrums, id: :uuid do |t|
      t.uuid :team_id
      t.date :date
      t.integer :points

      t.timestamps null: false
    end

  end
end
