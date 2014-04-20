class Admin::BaseController < ApplicationController

  #devise configuration
  before_action :require_admin!

  def require_admin!
    unless current_user.try(:admin?)
      flash[:error] = "Access denied!"
      redirect_to admin_sign_in_path
    end
  end

  layout 'admin'
end