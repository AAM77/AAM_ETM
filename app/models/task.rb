class Task < ApplicationRecord
  has_many :solo_tasks, class_name: "Task"
  has_many :group_tasks, class_name: "Task"
end
