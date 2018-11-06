class SessionsController < ApplicationController
  before_action :redirect_if_not_logged_in, except: [:new, :create]
  before_action :prevent_double_login


  def new
    @user = User.new
  end


  def create

    # Checks if the user is logging in using facebook, etc.
    # if so, searches for or creates a new account using the
    # information received
    if auth
      if auth[:provider] || auth[:uid]
        @user = User.find_from_auth_hash(auth).first

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
            flash[:warning] = "#{@user.errors.messages[:email].first}"
          end
        end # if @user
      end # if auth[:provider] || auth[:uid]

    # if the user is not logging in using facebook, etc.
    # searches for an existing account
    # or asks the user to create a new one
    else
      @user = User.search_for_email(params[:user][:email])
      binding.pry
      if @user && @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        redirect_to login_path
        flash[:warning] = "Invalid email or password. Please try again."
      end
    end
  end

  ####################
  # Ends the Session #
  ####################
  def destroy
    session.destroy
    redirect_to root_path
    flash[:warning] = "You have been signed out."
  end


  private

    def auth
      request.env['omniauth.auth']
    end

end
