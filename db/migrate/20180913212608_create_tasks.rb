class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :task_type
      t.integer :points_awarded
      t.date :deadline_date
      t.time :deadline_time

      t.timestamps
    end
  end
end
