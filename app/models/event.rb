class Event < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events

  validates :name, presence: true, presence: { message: "You must provide a name for this event." }

  scope :set_order, -> { order("tasks.group_task DESC, tasks.name ASC, tasks.max_participants ASC") }
  scope :admin, -> (user){ where(admin_id: user.id) }
  scope :not_admin, -> (user){ where.not(admin_id: user.id) }
  scope :with_tasks, -> { where(id: Task.pluck(:event_id)) }

  before_create :titleize_name
  after_create :set_admin_user

  #######################################
  # Sets the default order of the tasks #
  #######################################
  def order_tasks
    self.tasks.order("group_task ASC, user_completed_at ASC, name ASC")
  end

  ######################
  # Titleizes the Name #
  ######################
  def titleize_name
    self.name = self.name.titleize
  end

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

  #####################################################################
  # Checks if a particular user is participating in the event's tasks #
  #####################################################################
  def tasks_with_user(user)
    task_ids = []
    self.tasks.each do |task|
      if task.user_ids.include?(user.id)
        task_ids << task.id
      end
    end

    task_ids
  end

  ##############################################
  # deletes a user's association with an event #
  ##############################################

  def remove_from_event?(participant)
    if self.tasks_with_user(participant).empty?
      user_event = UserEvent.find_by_user_id_and_event_id(participant.id, self.id)
      user_event.delete
    end
  end


end
