class ApplicationController < ActionController::Base
  helper_method :current_user, :check_login_status

  private

    def current_user
      current_user ||= User.find_by(id: session[:user_id])
    end

    def logged_in?
      !!current_user
    end

    def check_login_status
      if logged_in?
        redirect_to user_path(current_user)
      else
        redirect_to login_path
      end
    end

end
