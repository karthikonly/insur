class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # authenticate every call, no part of application is to be used without login
  before_filter :authenticate_user!

  # configure permitted params for devise
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name])
      devise_parameter_sanitizer.permit(:account_update, keys:
        [:email, :password, :password_confirmation, :current_password, :name])
    end

    # check if current user is admin, else redirect to home page
    def check_admin
      redirect_to :root unless current_user.admin?
    end
end
