class UserSerializer < ActiveModel::Serializer
  attributes :crnt_user, :id, :first_name, :last_name, :telephone_num,
             :address, :email, :username, :total_points,
             :all_friends, :solo_tasks, :group_tasks, :friendship_id,
             :adminned_events, :friends_events

  has_many :events, through: :user_events, dependent: :destroy
  # has_many :friendships, dependent: :destroy
  # has_many :friends, through: :friendships, dependent: :destroy
  # has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  # has_many :inverse_friends, through: :inverse_friendships, source: :user, dependent: :destroy

  def crnt_user
    { id: current_user.id, username: current_user.username }
  end

  def all_friends
    (object.friends + object.inverse_friends).map do |friend|
      {
        id: friend.id,
        username: friend.username,
        events: friend.events.map { |event| { id: event.id, name: event.name, admin_id: event.admin_id } },
        friendship_id: Friendship.find_friendship_for(object, friend).id,
        current_user_id: current_user.id
      }
    end
  end

  def friendship_id
    f_id = nil;
    if object.id != current_user.id
      f_id = Friendship.where(["user_id = ? AND friend_id = ?", current_user.id, object.id]) ||
      Friendship.where(["user_id = ? AND friend_id = ?", object.id, current_user.id])
    end

    unless f_id.nil? || f_id.first.nil?
      f_id.first.id
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
    end
  end

  def adminned_events
    Event.admin(object).map do |event|
        {
          id: event.id,
          name: event.name,
          admin_id: event.admin_id,
          admin_user: User.find(event.admin_id).username
        }
    end
  end

  def solo_tasks
    object.tasks.map { |task| {
      id: task.id,
      name: task.name,
      event_id: task.event_id,
      admin_id: task.admin_id,
      event_name: Event.find(task.event_id).name,
      admin_user: User.find(task.admin_id).username } if task.group_task == false }.compact
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
end
