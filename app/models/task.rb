class Task < ApplicationRecord
  belongs_to :event
  has_many :user_tasks
  has_many :users, through: :user_tasks

  def add_participant(participant)
    if self.task_type == "Group Task"
      self.users << participant
      self.user_ids << participant.id
    elsif self.task_type == "Solo Task" && self.users.size != 1
      self.users << participant
      self.user_ids << participant.id
    end

    self.save
    participant.save
  end

  def list_participants
    list = self.users.map { |u| u.username.capitalize }
    if list.size == 1
      list.first
    else
      list.join(", ")
    end
  end

  def task_type
    self.group_task ? "Group Task" : "Solo Task"
  end

end
