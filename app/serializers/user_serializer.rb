class UserSerializer < ActiveModel::Serializer
  attributes :crnt_user, :id, :first_name, :last_name, :telephone_num,
             :address, :email, :username, :total_points,
             :all_friends, :all_friendships, :solo_tasks, :group_tasks

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
        friendships: friend.friendships.map { |friendship| { id: friendship.id, user_id: friendship.user_id, friend_id: friendship.friend_id } if friendship.user_id == current_user.id || friendship.friend_id == current_user.id }.compact
      }
    end
  end

  def all_friendships
    (object.friendships + object.inverse_friendships).map do |friendship|
      {
        id: friendship.id,
        user_id: friendship.user_id,
        friend_id: friendship.friend_id
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
