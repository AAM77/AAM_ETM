module UsersHelper

  def friend_link(user)
    if user.id != current_user.id
      if user.friend_ids_list.exclude?(current_user.id)
        link_to "Add Friend", friendships_path(friend_id: user),
        method: :post, class: "btn btn-info"
      else
        link_to "Unfriend #{@user.username}",
        friendship_path(Friendship.where(user_id: current_user, friend_id: user).first.id),
        method: :delete, class: "btn-sm btn-danger"
      end
    end
  end
end
