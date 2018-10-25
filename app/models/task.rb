class Task < ApplicationRecord
  belongs_to :event
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks

  validates :users, length: {
    maximum: :max_participants,
    message: "The task can have only #{:max_participants} number of participants."
  }

  scope :group_tasks, -> { where(group_task: true) }
  scope :solo_tasks, -> { where(group_task: false) }
  scope :not_complete, -> { where("admin_confirmed_completion_at IS NULL") }
  scope :admin_marked_complete, -> { where("admin_confirmed_completion_at IS NOT NULL") }

  before_validation :set_defaults
  before_create :titleize_name
  # after_create :assign_admin

  #############################################
  # Assigns the admin to be same as the event #
  #############################################

  # def assign_admin
  #   event = Event.find(self.event_id)
  #   self.admin_id = event.admin_id
  #   self.save
  # end

  ###########################
  # Checks if user id admin #
  ###########################
  def task_admin(user)
    self.admin_id == user.id
  end

  #########################
  # Adds a user to a task #
  #########################
  def add_participant(participant)
    event = Event.find(self.event_id)

    if self.task_type == "Group Task" # || (self.task_type == "Solo Task" && self.users.size != 1)
      self.users << participant
    elsif self.task_type == "Solo Task" && self.users.size != 1
      self.users << participant
    end

    participant.events << event unless participant.event_ids.include?(event_id)

    self.save
    participant.save
  end

  ##############################
  # Removes a user from a task #
  ##############################
  def remove_participant(participant)
    user_task = UserTask.find_by_user_id_and_task_id(participant.id, self.id)
    user_task.delete if user_task

    event = Event.find(self.event_id)
    event.remove_from_event?(participant)
  end

  ##########################################################
  # Lists the usernames of users participating in the task #
  ##########################################################
  def list_participants
    list = self.users
    if list.size == 1
      list.first.username
    else
      list.map { |u| u.username.capitalize }.join(", ")
    end
  end

  ######################
  # Labels a task type #
  ######################
  def task_type
    self.group_task ? "Group Task" : "Solo Task"
  end

  #######################################################################
  # marks a task complete if the admin and user both confirm completion #
  #######################################################################
  def mark_task_complete?
    if self.user_completed_at
      if self.admin_confirmed_completion_at
        self.completed = true
        self.save
      end
    end
  end

  ########################################################################################
  # determines how many points each user should get                                      #
  # I am choosing this method of point distribution to make it fair                      #
  # if a single user completes a group task, why shouldn't that person earn more points? #
  ########################################################################################
  def points_distributed_to_each_participant
    self.points_awarded / self.users.size
  end

  ##############################################################
  # handles the distribution of the points to each participant #
  ##############################################################
  def distribute_points
    self.users.each do |user|
      total_points = user.total_points + self.points_distributed_to_each_participant
      user.update(total_points: total_points)
    end
  end

  ##################################################################
  # sets the max_participants for a solo_task to 1                 #
  # even if a user manages to insert a different value             #
  # into the field for number of max people allowed to participate #
  ##################################################################
  def set_defaults
    if !self.group_task
      self.max_participants = 1
    end
  end


  ######################
  # Titleizes the Name #
  ######################
  def titleize_name
    self.name = self.name.titleize
  end

end
