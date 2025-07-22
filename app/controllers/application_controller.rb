class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?, :admin?
    include ActionController::Cookies
    include ActionController::RequestForgeryProtection
    protect_from_forgery with: :exception   
    before_action :set_csrf_cookie

    include Pundit::Authorization

    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  
    def logged_in?
      !!current_user
    end
  
    def admin?
      logged_in? && current_user.admin?
    end
    
    private

    def set_csrf_cookie
        cookies["CSRF-TOKEN"] = {
            value: form_authenticity_token,  
        }
    end

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    end
  end
  