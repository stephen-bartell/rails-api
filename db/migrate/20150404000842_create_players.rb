class CreatePlayers < ActiveRecord::Migration
  def change

    create_table :players, id: :uuid do |t|
      t.uuid :team_id

      t.string :slack_id
      t.string :name
      t.string :real_name
      t.string :email
      t.string :password_salt
      t.string :password_hash

      t.timestamps null: false
    end

  end
end
