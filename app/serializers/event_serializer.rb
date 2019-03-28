class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :admin_id, :deadline_date, :deadline_time

  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events, serializer: EventUserSerializer

end
