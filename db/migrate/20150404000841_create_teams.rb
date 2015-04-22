class CreateTeams < ActiveRecord::Migration
  def change

    create_table :teams, id: :uuid do |t|
      t.string :name
      t.string :auth_token
      t.integer :points, default: 0
      t.string :slack_id

      t.string :bot_url
      t.string :prompt_at
      t.string :remind_at
      t.string :summary_at
      t.string :timezone

      t.timestamps null: false
    end

  end
end
