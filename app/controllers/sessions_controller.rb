class SessionsController < ApplicationController
  before_action :redirect_if_not_logged_in, except: [:new, :create]
  before_action :prevent_double_login

  #########################################
  # Submits a request to display the view #
  #########################################
  def new
    @user = User.new
  end

  ###########################
  # Submits a request to    #
  # create a session        #
  ###########################
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
            flash[:warnings] = []
            @user.errors.messages.each { |error| flash[:warnings] << error.second.first }
            redirect_to root_path
          end
        end # if @user
      end # if auth[:provider] || auth[:uid]

    # if the user is not logging in using facebook, etc.
    # searches for an existing account
    # or asks the user to create a new one
    else
      @user = User.search_for_email(params[:user][:email]).first

      if @user && @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        flash[:warnings] = [ "Invalid email or password. Please try again." ]
        redirect_to login_path
      end
    end
  end

  ########################################
  # Submits a request to end the Session #
  ########################################
  def destroy
    session.destroy
    flash[:warnings] = [ "You have been signed out." ]
    redirect_to root_path
  end


  private

    def auth
      request.env['omniauth.auth']
    end

end
