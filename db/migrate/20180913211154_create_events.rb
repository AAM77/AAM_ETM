class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :admin_id
      t.date :deadline_date
      t.time :deadline_time

      t.timestamps
    end
  end
end
