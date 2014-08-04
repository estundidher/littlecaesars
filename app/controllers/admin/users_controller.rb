class Admin::UsersController < Admin::BaseController

  before_action :set_users, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html { @users = User.all }
      format.json { @users = User.order(:name) }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: t('messages.created', model:User.model_name.human) }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|

      update_params = user_params

      # required for settings form to submit when password is left blank
      if update_params[:password].blank?
        update_params.delete 'password'
        update_params.delete 'password_confirmation'
      end

      if @user.update(update_params)
        format.html { redirect_to [:admin, @user], notice: t('messages.updated', model:User.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: t('messages.deleted', model:User.model_name.human) }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@user.username
      flash[:error_details] = e
      redirect_to [:admin, @user]
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to [:admin, @user]
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_users
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit :admin,
                                   :username,
                                   :email,
                                   :password,
                                   :password_confirmation
    end
end