class UserEventSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :event_id
  
  belongs_to :user
  belongs_to :event
end
