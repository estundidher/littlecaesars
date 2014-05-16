class Admin::ProductTypesController < Admin::BaseController

  before_action :set_product_type, only: [:show, :edit, :update, :destroy]

  # GET /product_types
  # GET /product_types.json
  def index
    respond_to do |format|
      format.html { @product_types = ProductType.all }
      format.json { @product_types = ProductType.order(:name) }
    end
  end

  # GET /product_types/1
  # GET /product_types/1.json
  def show
  end

  # GET /product_types/new
  def new
    @product_type = ProductType.new
  end

  # GET /product_types/1/edit
  def edit
  end

  # POST /product_types
  # POST /product_types.json
  def create
    @product_type = ProductType.new(product_type_params)

    respond_to do |format|
      if @product_type.save
        format.html { redirect_to [:admin, @product_type], notice: 'ProductType was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_types/1
  # PATCH/PUT /product_types/1.json
  def update
    respond_to do |format|
      if @product_type.update(product_type_params)
        format.html { redirect_to [:admin, @product_type], notice: 'ProductType was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_types/1
  # DELETE /product_types/1.json
  def destroy
    begin
      @product_type.destroy
      respond_to do |format|
        format.html { redirect_to admin_product_types_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@product_type.name
      flash[:error_details] = e
      redirect_to [:admin, @product_type]
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to [:admin, @product_type]
    end
  end

  def update_product_types
    @product_types = ProductType.where(product_type_id:nil).order(:name).map{|s| [s.name, s.id]}.insert(0, "")
  end

  def autocomplete
    if(params[:selected] == '')
      render json: ProductType.where("name like ?", "%#{params[:term]}%").order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    else
      render json: ProductType.where("name like ? and id not in (?)", "%#{params[:term]}%", params[:selected].split(',').map(&:to_i)).order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_type
      @product_type = ProductType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_type_params
      params.require(:product_type).permit :name,
                                           :shoppable,
                                           :sizable,
                                           :additionable,
                                           :itemable,
                                           :max_additions,
                                           :max_additions_per_half
    end
end