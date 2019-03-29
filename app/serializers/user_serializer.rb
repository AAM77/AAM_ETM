class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :provider, :first_name,
             :last_name, :telephone_num, :address,
             :email, :username, :total_points, :all_friends

  has_many :user_events, dependent: :destroy
  has_many :events, through: :user_events, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user, dependent: :destroy


  def all_friends
    object.friends + object.inverse_friends
  end
end
