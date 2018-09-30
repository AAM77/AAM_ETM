class Event < ApplicationRecord
  has_many :tasks
  has_many :user_events
  has_many :users, through: :user_events

  scope :admin, -> (user){ where(admin_id: user.id) }
  scope :not_admin, -> (user){ where.not(admin_id: user.id) }
  scope :with_tasks, -> { where(id: Task.pluck(:event_id)) }

  after_create :set_admin_user

  def set_admin_user
    u = User.find(self.admin_id)
    u.event_ids << self.id
    u.events << self
    u.save
  end
end
