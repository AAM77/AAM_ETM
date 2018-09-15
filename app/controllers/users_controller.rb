class UsersController < ApplicationController
  before_action :check_login_status, except: [:index, :new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(username: params[:user][:username], password: params[:user][:password], email: params[:user][:email])

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to new_user_path
    end
  end

  def profile
    @user = current_user
  end

  def update_profile
    @user = current_user
  end



  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = current_user
  end

  def update
  end

  def

  def destroy
  end

end
