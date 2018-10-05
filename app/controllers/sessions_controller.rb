class SessionsController < ApplicationController
  before_action :check_login_status, except: [:new, :create]
  before_action :prevent_double_login


  def new
    @user = User.new
  end


  def create

    #binding.pry
    # Checks if the user is logging in using facebook, etc.
    # if so, searches for or creates a new account using the
    # information received
    if auth[:provider] || auth[:uid]

      @user = User.find_from_auth_hash(auth)
      #binding.pry
      if @user
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        @user = User.new_from_auth_hash(auth)
        if @user.save
          session[:user_id] = @user.id
          redirect_to user_path(@user)
        else
          redirect_to root_path
          flash[:warning] = "#{@user.errors.messages}"
        end
      end

    # if the user is not logging in using facebook, etc.
    # searches for and existing account
    # or asks the user to create a new one
    else
      @user = User.find_by(username: params[:user][:username])

      if @user && @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        redirect_to login_path
      end
    end
  end

  ####################
  # Ends the Session #
  ####################
  def destroy
    session.destroy
    redirect_to root_path
  end


  private

    def auth
      request.env['omniauth.auth']
    end

end
