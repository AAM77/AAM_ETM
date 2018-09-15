class SessionsController < ApplicationController
  before_action :check_login_status, except: [:new, :create]

  def new
    @user = User.new
  end

  def create

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
end
