class Admin::BaseController < ApplicationController

  #devise configuration
  before_action :authenticate_user!

  layout 'admin'
end