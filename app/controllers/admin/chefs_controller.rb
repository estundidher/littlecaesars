class Admin::ChefsController < Admin::BaseController

  before_action :set_chef, only: [:show, :edit, :update, :destroy]

  # GET /chefs
  # GET /chefs.json
  def index
    respond_to do |format|
      format.html { @chefs = Chef.all }
      format.json { @chefs = Chef.order(:name) }
    end
  end

  # GET /chefs/1
  # GET /chefs/1.json
  def show
  end

  # GET /chefs/new
  def new
    @chef = Chef.new
  end

  # GET /chefs/1/edit
  def edit
  end

  # POST /chefs
  # POST /chefs.json
  def create
    @chef = Chef.new(chef_params)

    respond_to do |format|
      if @chef.save
        format.html { redirect_to [:admin, @chef], notice: 'Chef was successfully created.' }
        format.json { render action: 'show', status: :created, location: @chef }
      else
        format.html { render action: 'new' }
        format.json { render json: @chef.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chefs/1
  # PATCH/PUT /chefs/1.json
  def update
    respond_to do |format|
      if @chef.update(chef_params)
        format.html { redirect_to [:admin, @chef], notice: 'Chef was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @chef.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chefs/1
  # DELETE /chefs/1.json
  def destroy
    begin
      @chef.destroy
      respond_to do |format|
        format.html { redirect_to admin_chefs_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@chef.name
      flash[:error_details] = e
      redirect_to [:admin, @chef]
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to [:admin, @chef]
    end
  end

  def update_chefs
    @chefs = Chef.where(chef_id:nil).order(:name).map{|s| [s.name, s.id]}.insert(0, "")
  end

  def autocomplete
    if(params[:selected] == '')
      render json: Chef.where("name like ?", "%#{params[:term]}%").order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    else
      render json: Chef.where("name like ? and id not in (?)", "%#{params[:term]}%", params[:selected].split(',').map(&:to_i)).order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chef
      @chef = Chef.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chef_params
      params.require(:chef).permit :name,
                                   :position,
                                   :facebook,
                                   :twitter,
                                   :plus,
                                   :pinterest,
                                   :avatar,
                                   :background
    end
end