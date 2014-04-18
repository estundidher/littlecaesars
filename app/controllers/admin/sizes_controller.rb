class Admin::SizesController < Admin::BaseController

  before_action :set_sizes, only: [:show, :edit, :update, :destroy]

  # GET /sizes
  # GET /sizes.json
  def index
    respond_to do |format|
      format.html { @sizes = Size.all }
      format.json { @sizes = Size.order(:name) }
    end
  end

  # GET /sizes
  # GET /sizes.json
  def list
    @sizes = Size.all
  end

  # GET /sizes/1
  # GET /sizes/1.json
  def show
  end

  # GET /sizes/new
  def new
    @size = Size.new
  end

  # GET /sizes/1/edit
  def edit
  end

  # POST /sizes
  # POST /sizes.json
  def create
    @size = Size.new size_params

    respond_to do |format|
      if @size.save
        format.html { redirect_to [:admin, @size], notice: 'Size was successfully created.' }
        format.json { render action: 'show', status: :created, location: @size }
      else
        format.html { render action: 'new' }
        format.json { render json: @size.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sizes/1
  # PATCH/PUT /sizes/1.json
  def update
    respond_to do |format|
      if @size.update(size_params)
        format.html { redirect_to [:admin, @size], notice: 'Size was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @size.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sizes/1
  # DELETE /sizes/1.json
  def destroy
    @size.destroy
    respond_to do |format|
      format.html { redirect_to admin_sizes_url }
      format.json { head :no_content }
    end
  end

  def update_sizes
    @sizes = Size.where(size_id:nil).order(:name).map{|s| [s.name, s.id]}.insert(0, "")
  end

  def autocomplete
    if(params[:selected] == '')
      render json: Size.where("name like ?", "%#{params[:term]}%").order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    else
      render json: Size.where("name like ? and id not in (?)", "%#{params[:term]}%", params[:selected].split(',').map(&:to_i)).order(:name).map{|s| [id:s.id, label:s.name, value:s.name]}.flatten
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sizes
      @size = Size.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def size_params
      params.require(:size).permit :name, :description
    end
end