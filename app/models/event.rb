class Event < ApplicationRecord
  has_many :tasks
  has_many :user_events
  has_many :users, through: :user_events

end
