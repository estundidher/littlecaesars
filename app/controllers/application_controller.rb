class ApplicationController < ActionController::Base

  #rescue_from Exception, :with => :render_error

  #def render_error
  #  respond_to do |type|
  #    type.html { render :template => "errors/error_404", :status => 404 }
  #    type.all  { render :nothing => true, :status => 404 }
  #  end
  #  true
  #end

  def after_sign_in_path_for(resource)
    case resource
      when Customer then pick_up_index_path
      when User     then admin_root_path
    end
  end

  def after_sign_up_path_for(resource)
    case resource
      when Customer then pick_up_index_path
      when User     then admin_root_path
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user
  before_action :check_pending_order

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :surname, :mobile, :username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :surname, :mobile, :username, :email, :password, :password_confirmation, :current_password) }
  end

  def set_current_user
    User.current = current_user
  end

  def check_pending_order
    if customer_signed_in? && current_customer.orders.pending.last.present?
      redirect_to checkout_path(current_customer.orders.pending.last.code)
    end
  end 
  
end

private
  SECURE_ACTIONS = {
    :OrdersController => [""]
    }

  # Called as a before_filter in controllers that have some https:// actions
  def require_ssl
    unless Rails.env.development? || request.ssl?
      redirect_to :protocol => 'https://', :action => action_name
      # we don't want to continue with the action, so return false from the filter
      return false
    end
  end

def default_url_options(options)
    defaults = {}    

    if USE_EXPLICIT_HOST_IN_ALL_LINKS
      # This will OVERRIDE only_path => true, not just set the default.
      options[:only_path] = false
      # Now set the default protocol appropriately:
      if actions = SECURE_ACTIONS[ (options[:controller] || controller_name).to_sym ] and 
         actions.include? options[:action]

        defaults[:protocol] = 'https://'
        defaults[:host] = SECURE_SERVER if defined? SECURE_SERVER
      else
        defaults[:protocol] = 'http://'
        defaults[:host] = NON_SECURE_SERVER if defined? NON_SECURE_SERVER
      end
    end
    return defaults
  end