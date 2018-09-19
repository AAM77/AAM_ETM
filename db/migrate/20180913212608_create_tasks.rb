class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :points_awarded
      t.integer :event_id
      t.date :deadline_date
      t.time :deadline_time
      t.boolean :group_task, default: false
      
      t.timestamps
    end
  end
end
