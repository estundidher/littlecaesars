class Admin::BaseController < ApplicationController

  #devise configuration
  before_action :authenticate_user!

  skip_before_action :check_pending_order

  layout 'admin'
end