class CreateUserGroupTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_group_tasks do |t|
      t.integer :user_id
      t.integer :group_task_id
      t.integer :task_id

      t.timestamps
    end
  end
end
