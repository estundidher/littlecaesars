class Admin::HomeController < Admin::BaseController

  skip_before_action :require_admin!, only: :sign_in

  def index
  end

  def sign_in
  end
end