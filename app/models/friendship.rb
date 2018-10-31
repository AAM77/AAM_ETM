class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  scope :sent, -> (user, friend){ where(user_id: user, friend_id: friend) }
  scope :received, -> (user, friend){ where(user_id: friend, friend_id: user) }

  ##########################################
  # Finds the friendship between two users #
  ##########################################
  def self.find_friendship_for(user, friend)
    list = []
    Friendship.sent(user, friend).each { |friendship| list << friendship }
    Friendship.received(user, friend).each { |friendship| list << friendship }
    list.uniq.first
  end

  private

  private

    ########################################################
    # Development method: deletes all orphaned friendships #
    ########################################################

    def self.end_invalid_friendships
      range = (1..17).to_a

      range.each do |n|
        u ||= User.find_by(id: n)
        unless u
          self.where(user_id: n).each { |f| f.destroy }
          self.where(friend_id: n).each { |f| f.destroy }
        end
      end
    end

end
