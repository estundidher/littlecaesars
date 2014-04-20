class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    case resource
      when Customer then root_path
      when User     then admin_root_path
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :surname, :mobile, :username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :surname, :mobile, :username, :email, :password, :password_confirmation, :current_password) }
  end

  def set_current_user
    User.current = current_user
  end
end