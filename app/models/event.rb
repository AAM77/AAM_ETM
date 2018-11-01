class Event < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events

  validates_presence_of :name, message: "You must provide a name for this event."
  validates_uniqueness_of :name, case_sensitive: false, message: "You already have an event with that name."

  before_create :titleize_name
  after_create :set_admin_user

  scope :set_order, -> { order("tasks.group_task DESC, tasks.name ASC, tasks.max_participants ASC") }
  scope :admin, -> (user){ where(admin_id: user.id) }
  scope :not_admin, -> (user){ where.not(admin_id: user.id) }
  scope :with_tasks, -> { where(id: Task.not_complete.pluck(:event_id)) }

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

  def remove_from_event(participant)
    if self.tasks_with_user(participant).empty?
      user_event = UserEvent.find_by_user_id_and_event_id(participant.id, self.id)
      self.user_ids.delete(participant.id)
      user_event.delete
    end
  end

  private

    #################################################
    # Development method: deletes all orphan events #
    #################################################

    def self.end_all_invalid_events

      range = (1..17).to_a

      range.each do |n|
        u ||= User.find_by(id: n)
        unless u
          self.where(admin_id: n).each { |e| e.destroy }
        end
      end
    end



end
