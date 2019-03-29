module ApplicationHelper

  ### FINISHED EDITING ###
  
  #######################################################
  # checks if the current user is friends with the user #
  #######################################################
  def friends?(user)
    friendship ||= Friendship.find_friendship_for(current_user, user)
  end
end
