module UsersHelper
  ### FINISHED EDITING ###

  #############################################################
  # Displays a friend link                                    #
  # links to the create action in the friendships controller  #
  #############################################################
  def add_friend_link(user)
    if user != current_user
      ("<span>" + (button_tag "Add Friend", class: "btn btn-info btn-xs index-add-friend-button", data: { crnt_user_id: "#{current_user.id}", friend_id: "#{user.id}" }) + "</span>").html_safe
    end
  end

  #############################################################
  # Displays an unfriend link                                 #
  # links to the destroy action in the friendships controller #
  #############################################################
  def unfriend_link(friendship)
    (link_to "Unfriend", friendship_path(friendship), method: :delete,
    data: { confirm: "Are you sure you want to unfriend this person?" }, class: yield)
  end

  ###########################################
  # Displays an add or remove friend button #
  ###########################################
  def add_remove_friend_button(user)
    if user.id != current_user.id
      friendship = friends?(user)
      friendship ? unfriend_link(friendship) { "btn-sm btn-danger" } : add_friend_link(user) { "btn btn-info" }
    end
  end

  ############################################################
  # conditional logic for displaying a friends dropdown menu #
  ############################################################
  def friends_dropdown(user)
    if user == current_user || friends?(user)
      yield
    end
  end

  #########################################
  # Links to Users and allows to unfriend #
  #########################################

  def link_to_user(user)
    (link_to user.username, user_path(user)) + (user == current_user ? "" : " <::> ") +
    (friends?(user) ? "<span>Your Friend</span>".html_safe : add_friend_link(user) { "" })
  end

  #####################################
  # Links to User on Users Index Page #
  #####################################

  def friends_page(friendship, user)
    if friendship.friend_id == user.id
      (link_to friendship.user.username, user_path(friendship.user))
    else
      (link_to friendship.friend.username, user_path(friendship.friend))
    end
  end

  ################################################################################
  # Displays the name and link to a friend's homepage                            #
  # If user page is current user's homepage, then provides an option to unfriend #
  ################################################################################
  def link_to_friend(friendship, user)
    if user == current_user
      friends_page(friendship, user) + " - ( " + unfriend_link(friendship) { "" } + " ) "
    else
      friends_page(friendship, user)
    end
  end

  #############################################
  # Links to the task and corresponding event #
  # that the user is taking part in           #
  #############################################
  def task_participating_in(task, user)
    (link_to task.name, event_task_path(task.event_id, task)) + ", in Event: " +
    (link_to Event.find(task.event_id).name, user_event_path(user, task.event_id)) + ", by: " +
    (link_to User.find(task.admin_id).username, user_path(task.admin_id))
  end

  #############################################
  # Links to the task and corresponding event #
  # that the user is taking part in           #
  #############################################
  def friend_event_participating_in(event, user)
    (link_to event.name, user_event_path(event.admin_id, event)) + ", by:" +
    (link_to User.find(event.admin_id).username, user_event_path(event.admin_id, event))
  end


  ##########################
  # Incomplete Group Tasks #
  ##########################
  def users_incomplete_group_tasks
    @user.tasks.group_tasks.not_complete
  end

  #########################
  # Incomplete Solo Tasks #
  #########################
  def users_incomplete_solo_tasks
    @user.tasks.solo_tasks.not_complete
  end

end
