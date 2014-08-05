class Admin::PlacesController < Admin::BaseController

  before_action :set_places, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  def index
    respond_to do |format|
      format.html { @places = Place.order(:name) }
      format.json { @places = Place.order(:name) }
    end
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)
    respond_to do |format|
      if @place.save
        format.html { redirect_to [:admin, @place], notice: t('messages.created', model:Place.model_name.human) }
        format.json { render action: 'show', status: :created, location: @place }
      else
        format.html { render action: 'new' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to [:admin, @place], notice: t('messages.updated', model:Place.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    begin
      @place.destroy
      respond_to do |format|
        format.html { redirect_to admin_places_url, notice: t('messages.deleted', model:Place.model_name.human) }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@place.name
      flash[:error_details] = e
      redirect_to [:admin, @place]
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to [:admin, @place]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_places
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit :name,
                                    :enabled,
                                    :printer_name,
                                    :printer_ip,
                                    :abn,
                                    :code,
                                    :address,
                                    :phone,
                                    :description,
                                    :map,
                                    :photo
    end
end