class Task < ApplicationRecord
  belongs_to :event
  has_many :user_tasks
  has_many :users, through: :user_tasks

  def list_participants
    list = self.users.map { |u| u.username.capitalize }
    if list.size == 1
      list.first
    else
      list.join(", ")
    end
  end

  def task_type
    self.group_task ? "Group Task" : "Solo Task"
  end

end
