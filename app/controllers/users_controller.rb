class UsersController < ApplicationController
  before_action :check_login_status, except: [:index, :new, :create]
  before_action :set_user, except: [:index, :new, :create, :destroy]
  before_action :prevent_double_login


  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create

    @user = User.find_by(username: params[:user][:username])
    @email = User.find_by(email: params[:user][:email])

    if @user || @email
      flash[:warning] = "That email or username is not valid. Please choose something else."
      redirect_to new_user_path

    elsif  params[:user][:username].blank? || params[:user][:email].blank? || params[:user][:password].blank?
      flash[:warning] = "YOU MUST FILL OUT ALL FIELDS!!"
      redirect_to new_user_path

    elsif params[:user][:username].match(/[\?\<\>\'\,\?\[\]\}\{\=\-\)\(\*\&\^\%\$\#\`\~\{\}\@]/)
      flash[:warning] = "The username can contain only letters, digits, periods, and underscores"
      redirect_to new_user_path

    elsif (5 > params[:user][:username].length) || (params[:user][:username].length > 20)
      flash[:warning] = "The length of the username must be between 5 and 20 characters long."
      redirect_to new_user_path

    elsif (5 > params[:user][:password].length) || (params[:user][:password].length > 30)
      flash[:warning] = "The length of the password must be between 5 and 30 characters long."
      redirect_to new_user_path

    else
      @user = User.new(user_params)

      if @user.save
        session[:user_id] = @user.id
        redirect_to user_path(@user)
        flash[:success] = "You have successfully registered!"
      else
        redirect_to new_user_path
      end
    end
  end

  def profile
  end

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to profile_user_path(@user)
  end

  def destroy
    User.destroy(current_user.id)
    redirect_to root_path
    flash[:warning] = "You deleted your account."
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :telephone_num, :address, :email, :username, :password)
    end

end


def random
  puts num = Random.new.rand(20)
  if num != 19
    random
  end
end
