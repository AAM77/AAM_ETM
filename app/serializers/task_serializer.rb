class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :admin_id, :event_id, :in_event, :points_awarded, :max_participants,
             :deadline_date, :group_task, :completed, :permission_to_join

  belongs_to :event
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks

  def in_event
    event = Event.find(object.event_id)
    { id: event.id, name: event.name }
  end

##############################################################################


def friendship_status
  Friendship.where(["user_id = ? AND friend_id = ?", current_user.id, object.admin_id]) ||
  Friendship.where(["user_id = ? AND friend_id = ?", object.admin_id, current_user.id])
end

####################################################
# Determines if the visting user can join the task #
####################################################
def permission_to_join
  if friendship_status || object.admin_id == current_user.id
    task_availability
  else
    "Cannot Join"
  end
end


#########################################################
# Determines if a user is participating in an event     #
# Displays 'Join Task' or 'Leave Task' link accordingly #
#########################################################

def task_availability
  unless object.completed
    if object.user_ids.include?(current_user.id)
      if object.users.size <= object.max_participants
        "<a data-confirm='Are you sure you wish to leave task: #{object.name}?' rel='nofollow' data-method='delete' href='/users_tasks/#{object.id}'>Leave Task</a>"
        # link_to "Leave Task", users_task_path(task), method: :delete, data: { confirm: "Are you sure you wish to leave task: #{task.name}?"}
      end

    elsif object.users.size < object.max_participants
      unless object.user_completed_at
        if object.user_ids.exclude?(current_user.id)
          "<a rel='nofollow' data-method='post' href='/users_tasks.#{object.id}?id=#{object.id}'>Join Task</a>"
          # link_to "Join Task", users_tasks_path(object, id: object.id), method: :post
        end
      end

    else
      "Task Full"
    end
  end
end


end
