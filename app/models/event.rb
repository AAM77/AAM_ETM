class Event < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events

  validates :name, presence: true, presence: { message: "You must provide a name for this event." }

  scope :admin, -> (user){ where(admin_id: user.id) }
  scope :not_admin, -> (user){ where.not(admin_id: user.id) }
  scope :with_tasks, -> { where(id: Task.pluck(:event_id)) }

  after_create :set_admin_user

  ################################################
  # Adds this event to an admin user's event_ids #
  ################################################
  def set_admin_user
    u = User.find(self.admin_id)
    u.event_ids << self.id
    u.events << self
    u.save
  end


  ###############################
  # Displays all error messages #
  ###############################
  def display_errors
    self.errors.messages.each do |message|
      message
    end
  end

end
