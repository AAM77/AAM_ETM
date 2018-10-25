class UsersController < ApplicationController
  before_action :check_login_status, except: [:index, :new, :create, :show]
  before_action :set_user, except: [:index, :new, :create, :destroy]
  before_action :prevent_double_login


  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  ##########################################
  # Handles the Logic for Account Creation #
  ##########################################
  def create

    # prevents multiple accounts with the same username or email
    # via a case Insensitive seearch for username and email
    @user = User.search_for_username(params[:user][:username])
    @email = User.search_for_email(params[:user][:email])

    if @user || @email
      flash[:warning] = "That email or username is not valid. Please choose something else."
      redirect_to new_user_path

    # prevents form submission with blank entries
    elsif  params[:user][:username].blank? || params[:user][:email].blank? || params[:user][:password].blank?
      flash[:warning] = "YOU MUST FILL OUT ALL FIELDS!!"
      redirect_to new_user_path

    # prevents the user from using most special characters
    elsif params[:user][:username].match(/[\?\<\>\'\,\?\[\]\}\{\=\-\)\(\*\&\^\%\$\#\`\~\{\}\@]/)
      flash[:warning] = "The username can contain only letters, digits, periods, and underscores"
      redirect_to new_user_path

    # forces the usernam to be a specific length
    elsif (5 > params[:user][:username].length) || (params[:user][:username].length > 20)
      flash[:warning] = "The length of the username must be between 5 and 20 characters long."
      redirect_to new_user_path

    # forces the password to be a specific length
    elsif (5 > params[:user][:password].length) || (params[:user][:password].length > 30)
      flash[:warning] = "The length of the password must be between 5 and 30 characters long."
      redirect_to new_user_path

    # if all of the above conditions are true, then create and validate the new account
    else
      @user = User.new(user_params)

      # if it passes validations, creates the account, logs in the user, and flashes a success message
      if @user.save
        session[:user_id] = @user.id
        redirect_to user_path(@user)
        flash[:success] = "You have successfully registered!"
      else
        redirect_to new_user_path
      end
    end
  end

  # handles routing to the user's account details
  def profile
  end

  # handles routing to the user's show page
  def show
    @adminned_events = Event.admin(@user)
  end

  # handles routing to the user's account edit page
  def edit
  end

  # handles updating the user's account
  def update
    @user.update(user_params)
    redirect_to profile_user_path(@user)
  end

  # handles deleting a user's account
  def destroy
    User.destroy(current_user.id)
    redirect_to root_path
    flash[:warning] = "You deleted your account."
  end

  private

    # finds and sets the user
    def set_user
      @user = User.find(params[:id])
    end


    def user_params
      params.require(:user).permit(:first_name, :last_name, :telephone_num, :address, :email, :username, :password)
    end

end
