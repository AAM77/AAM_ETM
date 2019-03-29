class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :admin_id, :deadline_date, :deadline_time, :admin_user

  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events, serializer: EventUserSerializer


  def admin_user
    u = User.find(object.admin_id)
    { id: u.id, username: u.username }
  end
  
end
