class User < ApplicationRecord
  has_many :user_events
  has_many :user_group_tasks
  has_many :events, through: :user_events
  has_many :solo_tasks, class_name: "Task"
  has_many :group_tasks, through: :user_group_tasks, class_name: "Task"

  has_secure_password
  
end
