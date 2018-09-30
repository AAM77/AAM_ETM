class Task < ApplicationRecord
  belongs_to :event
  has_many :user_tasks
  has_many :users, through: :user_tasks

  scope :group_tasks, -> { where(group_task: true) }
  scope :solo_tasks, -> { where(group_task: false) }
  scope :not_complete, -> { where(completed: nil) }

  before_validation :set_defaults

  # Adds a user to a task
  def add_participant(participant)
    event = Event.find(self.event_id)
    if self.task_type == "Group Task"
      self.users << participant
      participant.events << event

    elsif self.task_type == "Solo Task" && self.users.size != 1
      self.users << participant
      participant.events << event
    end

    self.save
    participant.save
  end

  # Remobes a user from a task
  def remove_participant(participant)
    task = self
    user_task = UserTask.find_by_user_id_and_task_id(participant.id, task.id)

    if user_task
      user_task.delete
    end
  end

  # Lists the usernames of users participating in the task
  def list_participants
    list = self.users.map { |u| u.username.capitalize }
    if list.size == 1
      list.first
    else
      list.join(", ")
    end
  end

  # Labels a task type
  def task_type
    self.group_task ? "Group Task" : "Solo Task"
  end

  def points_distributed_to_each_participant
    self.points_awarded / self.users.size
  end

  def mark_task_complete?
    if self.user_completed_at
      if self.admin_confirmed_completion_at
        self.completed = true
        self.save
      end
    end
  end

  def distribute_points
    if self.completed
      self.users.each do |user|
        user.total_points = user.total_points + self.points_distributed_to_each_participant
        user.save
      end
    end
  end

  def set_defaults
    if !self.group_task
      self.max_participants = 1
    end
  end

end
