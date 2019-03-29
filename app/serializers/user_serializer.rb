class UserSerializer < ActiveModel::Serializer
  attributes :crnt_user, :id, :first_name, :last_name, :telephone_num,
             :address, :email, :username, :total_points,
             :all_friends, :solo_tasks, :group_tasks

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
        events: friend.events.map { |event| { id: event.id, name: event.name, admin_id: event.admin_id } }
      }
    end
  end

  def solo_tasks
    object.tasks.map { |task| { id: task.id, name: task.name, admin_id: task.admin_id, group_task: task.group_task } if task.group_task == false }.compact
  end

  def group_tasks
    object.tasks.map { |task| { id: task.id, name: task.name, admin_id: task.admin_id, group_task: task.group_task } if task.group_task == true }.compact
  end
end
