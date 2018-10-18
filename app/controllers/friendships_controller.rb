class FriendshipsController < ApplicationController

  ######################################
  # Creates a Friendship between users #
  ######################################
  def create
    #binding.pry

    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:success] = "Added friend successfully."
      redirect_to root_url
    else
      flash[:warning] = "Unable to add friend."
      redirect_to root_url
    end
  end

  #####################################
  # Allows a user to unfriend someone #
  #####################################
  def destroy
    #binding.pry
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:warning] = "You ended this friendship"
    redirect_to user_path(current_user)
  end

end