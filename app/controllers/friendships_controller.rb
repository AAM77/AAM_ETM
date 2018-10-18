class FriendshipsController < ApplicationController

  ######################################
  # Creates a Friendship between users #
  ######################################
  def create
    #binding.pry
    @user = User.find(params[:friend_id])
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:success] = "Added friend successfully."
      redirect_to users_path
    else
      flash[:warning] = "Unable to add friend."
      redirect_to users_path
    end
  end

  #####################################
  # Allows a user to unfriend someone #
  #####################################
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:warning] = "You ended this friendship"
    redirect_to user_path(current_user)
  end

end
