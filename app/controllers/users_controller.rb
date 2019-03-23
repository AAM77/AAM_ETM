class UsersController < ApplicationController
  before_action :redirect_if_not_logged_in, except: [:new, :create]
  before_action :prevent_double_login
  before_action :user_exists?, except: [:index, :new, :create, :destroy]
  before_action :set_user, except: [:index, :new, :create, :destroy]



  def index
    @users = User.all.order(:username)
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new
  end

  ##########################################
  # Handles the Logic for Account Creation #
  ##########################################
  def create
    @user = User.new(user_params)

    # If it passes validations, creates the account, logs in the user, and flashes a success message.
    # Otherwise, it stores the validation error messages to display them in the view.
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "You have successfully registered!"
      redirect_to user_path(@user)
    else
      flash[:warnings] = []
      @user.errors.messages.each { |error| flash[:warnings] << error.second.first }
      redirect_to new_user_path
    end
  end

  #################################################
  # handles routing to the user's account details #
  #################################################
  def profile
    respond_to do |format|
      format.html { render :profile }
      format.json { render json: @user }
    end
  end

  ###########################################
  # handles routing to the user's show page #
  ###########################################
  def show
    @friends_events = Event.not_admin(@user)
    @adminned_events = Event.admin(@user)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: { adminned_events: @adminned_events, friends_events: @friends_events } }
    end
  end

  ###################################################
  # handles routing to the user's account edit page #
  ###################################################
  def edit
  end

  #######################################
  # handles updating the user's account #
  #######################################
  def update
    @user.update(user_params.except(:email))
    if @user.errors.any?
      flash[:warnings] = []
      @user.errors.messages.each { |error| flash[:warnings] << error.second.first }
    else
      flash[:success] = "Successfully updated details" unless @user.errors.any?
    end
    redirect_to edit_user_path(@user)
  end

  #####################################
  # handles deleting a user's account #
  #####################################
  def destroy
    User.destroy(current_user.id)
    redirect_to root_path
    flash[:warnings] = [ "You deleted your account." ]
  end

  private

    ###########################
    # finds and sets the user #
    ###########################
    def set_user
      @user = User.find_by(id: params[:id])
    end

    ##########################################
    # Deals with the issue of orphaned users #
    ##########################################
    def user_exists?
      unless set_user
        redirect_to users_path
        flash[:warnings] = [ "That user does not exist" ]
      end
    end

    #############################################
    # A listing of the params permitted for use #
    #############################################
    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :telephone_num,
        :address,
        :email,
        :username,
        :password
      )
    end

end
