class SessionsController < ApplicationController
  before_action :check_login_status, except: [:new, :create]

  def new
    @user = User.new
  end

  def create

    @user = User.find_or_create_from_auth_hash(auth)
    # def create
    # if @user = User.find_by(uid: auth['uid'])
    #   session[:user_id] = @user.id
    # else
    #   @user = User.create(uid: auth['uid'], name: auth['info']['name'], email: auth['info']['email'])
    #   session[:user_id] = @user.id
    # end

    @user = User.find_by(username: params[:user][:username])

    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to login_path
    end
  end

  def destroy
    session.destroy
    redirect_to root_path
  end

  private

    def auth
      request.env['omniauth.auth']
    end

end
