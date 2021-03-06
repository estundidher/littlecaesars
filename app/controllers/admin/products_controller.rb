class Admin::ProductsController < Admin::BaseController

  before_action :set_products, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index

    @product = params[:product].present? ? Product.new(product_params) : Product.new

    query = Product.all

    filter = false

    if @product.name?
      query = query.where('name ilike ?', "%#{@product.name}%")
      filter = true
    end

    if @product.product_type_id?
      query = query.where(product_type_id:@product.product_type_id)
      filter = true
    end

    unless params[:category_id].nil? or params[:category_id].empty?
      query = query.joins(:categories)
                   .where(categories: {id:params[:category_id].to_i})
      filter = true
    end

    unless filter
      query = query.limit 50
    end

    respond_to do |format|
      format.html { @products = query.order(:name) }
      format.json { @products = query.order(:name) }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to [:admin, @product], notice: t('messages.created', model:Product.model_name.human) }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [:admin, @product], notice: t('messages.updated', model:Product.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    begin
      @product.destroy
      respond_to do |format|
        format.html { redirect_to admin_products_url, notice: t('messages.deleted', model:Product.model_name.human) }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@product.name
      flash[:error_details] = e
      redirect_to [:admin, @product]
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to [:admin, @product]
    end
  end

  def update_products
    @products = Product.where(product_id:nil).order(:name).map{|s| [s.name, s.id]}.insert(0, "")
  end

  def autocomplete
    if(params[:selected] == '')
      render json: Product.where("name like ?", "%#{params[:term]}%").order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    else
      render json: Product.where("name like ? and id not in (?)", "%#{params[:term]}%", params[:selected].split(',').map(&:to_i)).order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    end
  end

  def options
    type = ProductType.find(params[:id])
    render partial: 'options', locals: {product:Product.new(type:type)}, layout: nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_products
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit :name,
                                      :enabled,
                                      :description,
                                      :photo,
                                      :photo_left,
                                      :photo_right,
                                      :photo_showcase,
                                      :price,
                                      :product_type_id,
                                      :item_ids => [],
                                      :category_ids => []
    end
end