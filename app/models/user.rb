class User < ApplicationRecord
  has_many :user_events
  has_many :user_tasks
  has_many :events, through: :user_events
  has_many :tasks, through: :user_tasks

  has_secure_password

end
