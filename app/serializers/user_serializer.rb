class UserSerializer < ActiveModel::Serializer
  attributes :current_user_id, :id, :username, :total_points,
             :all_friends, :solo_tasks, :group_tasks, :friendship_id,
             :adminned_events, :friends_events, :friends_with_current_user

#  has_many :events, through: :user_events, dependent: :destroy

  def current_user_id
    current_user.id
  end

  def all_friends
    (object.friends + object.inverse_friends).map do |friend|
      {
        id: friend.id,
        username: friend.username,
        #events: friend.events.map { |event| { id: event.id, name: event.name, admin_id: event.admin_id } if event.admin_id == friend.id }.compact,
        friendship_id: Friendship.find_friendship_for(object, friend).id,
        current_user_id: current_user.id
      }
    end
  end

  def friendship_id
    f_id = nil;
    if object.id != current_user.id
      f_id = Friendship.where(["user_id = ? AND friend_id = ?", current_user.id, object.id]).first ||
      Friendship.where(["user_id = ? AND friend_id = ?", object.id, current_user.id]).first
    end

    unless f_id.nil?
      f_id.id
    end
  end

  def friends_events
    Event.not_admin(object).with_tasks.map do |event|
      if event.user_ids.include?(object.id)
        {
          id: event.id,
          name: event.name,
          admin_id: event.admin_id,
          admin_user: User.find(event.admin_id).username
        }
      end
    end.compact
  end

  def adminned_events
    Event.admin(object).map do |event|
        {
          id: event.id,
          name: event.name,
          admin_id: event.admin_id,
          admin_user: User.find(event.admin_id).username
        }
    end.compact
  end

  def solo_tasks
    object.tasks.map { |task|
      {
        id: task.id,
        name: task.name,
        event_id: task.event_id,
        admin_id: task.admin_id,
        event_name: Event.find(task.event_id).name,
        admin_user: User.find(task.admin_id).username
      } if task.group_task == false
    }.compact
  end

  def group_tasks
    object.tasks.map { |task| {
      id: task.id,
      name: task.name,
      event_id: task.event_id,
      admin_id: task.admin_id,
      event_name: Event.find(task.event_id).name,
      admin_user: User.find(task.admin_id).username } if task.group_task == true }.compact
  end

  def friends_with_current_user
    true if all_friends.select { |friend| friend[:id] == current_user.id }[0]
  end
end
