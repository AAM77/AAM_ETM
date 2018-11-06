class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  helper_method :redirect_if_not_logged_in
  helper_method :redirect_if_logged_in_and_on_signup_or_login

  before_action :redirect_if_logged_in_and_on_signup_or_login

  private

    ##############################################
    # Retrieves current user if one is logged in #
    ##############################################
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    ########################################
    # Returns true/false if not logged in  #
    ########################################
    def logged_in?
      !!current_user
    end

    ###############################################################################
    # Returns the user to the homepage if not the same as current logged in user  #
    ###############################################################################
    def redirect_if_not_logged_in
      unless logged_in?
        flash[:warning] = "You must sign up or log in to access this page."
        redirect_to root_path
      end
    end

    #########################################################################################
    # Checks the current path                                                               #
    # used in: [1] :signup_or_login_page, [2] :redirect_if_logged_in_and_on_signup_or_login #
    # used in: [3] :prevent_double_login                                                    #
    #########################################################################################
    def current_page
      request.path
    end

    ##############################################################
    # Checks if the current page is a signup or login page       #
    # used in: [1] :redirect_if_logged_in_and_on_signup_or_login #
    ##############################################################
    def signup_or_login_page?
      current_page == new_user_path || current_page == login_path || current_page == '/sessions/create'
    end


    ##################################################################
    # does not let a logged_in user access the signup or login pages #
    ##################################################################
    def redirect_if_logged_in_and_on_signup_or_login
      if logged_in? && signup_or_login_page?
        flash[:warning] = "Stop it! You are already logged in!"
        redirect_to user_path(current_user)
      end
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
