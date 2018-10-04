class SessionsController < ApplicationController
  before_action :check_login_status, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    #@user = User.from_omniauth(auth)
    #binding.pry
    if auth[:provider] || auth[:uid]
      #binding.pry
      @user = User.find_from_auth_hash(auth)
      binding.pry
      if @user
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        @user = User.create_from_auth_hash(auth)
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      end

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

  # def create
  # if @user = User.find_by(uid: auth['uid'])
  #   session[:user_id] = @user.id
  # else
  #   @user = User.create(uid: auth['uid'], name: auth['info']['name'], email: auth['info']['email'])
  #   session[:user_id] = @user.id
  # end

  def destroy
    session.destroy
    redirect_to root_path
  end

  private

    def auth
      request.env['omniauth.auth']
    end

end
