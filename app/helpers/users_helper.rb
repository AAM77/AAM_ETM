module UsersHelper

  ###########################################
  # Displays an add or remove friend button #
  ###########################################
  def add_remove_friend_button(user)
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

  ############################################################
  # conditional logic for displaying a friends dropdown menu #
  ############################################################
  def friends_dropdown(user)
    if user == current_user || user.friend_ids_list.include?(current_user.id)
      yield
    end
  end

  #######################################################################################
  # Displays the name and link to a friend's homepage as well as the option to unfriend #
  #######################################################################################
  def friend_name(friendship, user)
    if friendship.friend_id == user.id
      (link_to friendship.user.username, user_path(friendship.user)) +
      (link_to " - ( Unfriend )", friendship_path(friendship), method: :delete if @user == current_user)
    else
      (link_to friendship.friend.username, user_path(friendship.friend)) +
      (link_to " - ( Unfriend )", friendship_path(friendship), method: :delete if @user == current_user)
    end
  end

  def task_participating_in(task, user)
    (link_to task.name.titleize, event_task_path(task.event_id, task)) + " in Event: " +
    (link_to Event.find(task.event_id).name, user_event_path(user, task.event_id))
  end

end
