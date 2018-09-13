class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.date :date_created
      t.date :event_date
      t.date :deadline_date
      t.time :deadline_time

      t.timestamps
    end
  end
end
