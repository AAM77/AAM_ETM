class UsersController < ApplicationController
  before_action :check_login_status, except: [:index, :new, :create]
  before_action :set_user, except: [:index, :new, :create, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to new_user_path
    end
  end

  def profile
  end

  def update_profile
  end

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def destroy
    User.destroy(current_user.id)
    redirect_to root_path
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :telephone_num, :address, :email, :username, :password)
    end

end
