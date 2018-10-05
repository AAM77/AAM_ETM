class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  helper_method :check_login_status, :signup_or_login_page?

  private

    ##############################################
    # Retrieves current user if one is logged in #
    ##############################################
    def current_user
      current_user ||= User.find_by(id: session[:user_id])
    end

    ##############################################
    # Returns true/false if not logged in  #
    ##############################################
    def logged_in?
      !!current_user
    end

    def signup_or_login_page?
      current_page?(new_user_path) || current_page?(login_path) || current_page?('/sessions/create')
    end

    ###############################################################################
    # Returns the user to the homepage if not the same as current logged in user  #
    ###############################################################################
    def check_login_status
      redirect_to root_path unless logged_in?
    end

    ###########################
    # Checks the current path #
    ###########################
    def current_page
      request.path
    end

    #######################################################################
    # Prevents a user from logging in using omniauth if already logged in #
    #######################################################################
    def prevent_double_login

      if logged_in?
        if current_page =='/auth/facebook' || current_page =='/auth/github' || current_page =='/auth/google_oauth2'
          redirect_to user_path(current_user)
        elsif current_page =='/auth/facebook/callback' || current_page =='/auth/github/callback' || current_page =='/auth/google_oauth2/callback'
          redirect_to user_path(current_user)
        end
      end
    end

end
