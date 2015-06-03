class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :jid, index: true
      t.string :method_string
      t.string :reoccurrence_crontab
      t.datetime :run_at
      t.integer :run_count
      t.string :status

      t.uuid :resource_id
      t.string :resource_type

      t.timestamps null: false
    end
  end
end
