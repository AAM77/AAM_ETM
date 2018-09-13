class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.date :deadline_date
      t.time :deadline_time
      t.string :solo_task
      t.string :group_task

      t.timestamps
    end
  end
end
