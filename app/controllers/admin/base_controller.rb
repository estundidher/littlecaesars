class Admin::BaseController < ApplicationController

  #devise configuration
  before_action :authenticate_user!

  def set_current_user
    User.current = current_user
  end

  def require_admin
    unless current_user.try(:admin?)
      flash[:error] = "You are not an admin"
      redirect_to root_path
    end
  end

  before_filter :set_current_user

  layout 'admin'
end