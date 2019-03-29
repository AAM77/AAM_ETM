class FriendshipSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :friend_id

  belongs_to :user
  belongs_to :friend, class_name: "User"


end
