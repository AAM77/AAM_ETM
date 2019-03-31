class FriendshipsController < ApplicationController
  before_action :redirect_if_not_logged_in


  #########################
  # Lists all friendships #
  #########################
  #
  # def index
  #   friendships = Friendship.all
  #   render json: friendships
  # end

  ######################################
  # Creates a Friendship between users #
  ######################################
  def create
    friendship = current_user.friendships.build(friend_id: params[:friend_id])

    if friendship.save
      flash[:success] = "Added friend successfully."
      redirect_to user_path(params[:friend_id])
    else
      flash[:warnings] = [ "Unable to add friend." ]
      redirect_to users_path
    end
  end

  #####################################
  # Allows a user to unfriend someone #
  #####################################
  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy

    respond_to do |format|
      format.js
    end
    flash[:warnings] = [ "You ended the friendship." ]
  end

end
