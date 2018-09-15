class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  helper_method :check_login_status, :signup_or_login_page?

  private

    def current_user
      current_user ||= User.find_by(id: session[:user_id])
    end

    def logged_in?
      !!current_user
    end

    def signup_or_login_page?
      current_page?(new_user_path) || current_page?(login_path) || current_page?('/sessions/create')
    end

    def check_login_status
      redirect_to root_path unless logged_in?
      # if logged_in? && !current_page?(user_path(current_user))
      #   redirect_to user_path(current_user)
      # elsif !signup_or_login_page?
      #   redirect_to login_path
      # end
    end

end
