class Admin::CategoriesController < Admin::BaseController

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    respond_to do |format|
      format.html { @categories = Category.all }
      format.json { @categories = Category.order(:name) }
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to [:admin, @category], notice: t('messages.created', model:Category.model_name.human) }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [:admin, @category], notice: t('messages.updated', model:Category.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    begin
      @category.destroy
      respond_to do |format|
        format.html { redirect_to admin_categories_url, notice: t('messages.deleted', model:Category.model_name.human) }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@category.name
      flash[:error_details] = e
      redirect_to [:admin, @category]
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to [:admin, @category]
    end
  end

  def update_categories
    @categories = Category.where(category_id:nil).order(:name).map{|s| [s.name, s.id]}.insert(0, "")
  end

  def autocomplete
    if(params[:selected] == '')
      render json: Category.where("name like ?", "%#{params[:term]}%").order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    else
      render json: Category.where("name like ? and id not in (?)", "%#{params[:term]}%", params[:selected].split(',').map(&:to_i)).order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit :name,
                                       :item_ids => []
    end
end