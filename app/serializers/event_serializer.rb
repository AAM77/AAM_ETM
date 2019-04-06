class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :admin_id, :deadline_date, :deadline_time, :admin_user,
             :incomplete_tasks, :complete_tasks

  # has_many :users, through: :user_events, serializer: EventUserSerializer


  def admin_user
    u = User.find(object.admin_id)
    { id: u.id, username: u.username }
  end



  def incomplete_tasks
    object.order_tasks.not_complete.map do |task|
      {
        id: task.id,
        name: task.name,
        points_awarded: task.points_awarded,
        event_id: task.event_id,
        admin_id: task.admin_id,
        deadline_date: task.deadline_date,
        deadline_time: task.deadline_time,
        max_participants: task.max_participants,
        group_task: task.group_task,
        user_completed_at: task.user_completed_at,
        admin_confirmed_completion_at: task.admin_confirmed_completion_at,
        completed: task.completed,
        users: task.users.map { |user| { id: user.id, username: user.username } }
      }
    end
  end

  def complete_tasks
    object.order_tasks.admin_marked_complete.map do |task|
      {
        id: task.id,
        name: task.name,
        points_awarded: task.points_awarded,
        event_id: task.event_id,
        admin_id: task.admin_id,
        deadline_date: task.deadline_date,
        deadline_time: task.deadline_time,
        max_participants: task.max_participants,
        group_task: task.group_task,
        user_completed_at: task.user_completed_at,
        admin_confirmed_completion_at: task.admin_confirmed_completion_at,
        completed: task.completed,
        users: task.users.map { |user| { id: user.id, username: user.username } }
      }
    end
  end

end
