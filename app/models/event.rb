class Event < ApplicationRecord
  has_many :user_events
  has_many :user_admin_events
  has_many :admins, class_name: "User", through: :user_admin_events
  has_many :users, through: :user_events

end
