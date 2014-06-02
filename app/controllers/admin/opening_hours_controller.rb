class Admin::OpeningHoursController < Admin::BaseController

  before_action :set_opening_hour, only: [:edit, :update, :destroy, :add_shift]
  before_action :set_place, only: [:new]

  # GET /places/:place_id/opening_hours/new
  def new
    @opening_hour = @place.opening_hours.build
    @opening_hour.shifts.build
    render 'modal', layout: nil
  end

  # GET /places/:place_id/opening_hours/:id/edit
  def edit
    @opening_hour.shifts.build if @opening_hour.shifts.empty?
    render 'modal', layout: nil
  end

  # POST /places/:place_id/opening_hours
  def create
    @opening_hour = OpeningHour.new(opening_hour_params)
    if @opening_hour.save
      render partial:'list', locals: {place:@opening_hour.place}, layout:nil
    else
      render partial:'form', locals: {opening_hour:@opening_hour}, layout:nil, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /places/:place_id/opening_hours/:id
  # PATCH/PUT /places/:place_id/opening_hours/:id.json
  def update
    if @opening_hour.update(opening_hour_params)
      render partial:'list', locals:{place:@opening_hour.place}, layout:nil
    else
      render partial:'form', locals:{opening_hour:@opening_hour}, layout:nil, status: :unprocessable_entity
    end
  end

  # DELETE /places/:place_id/opening_hours/:id
  # DELETE /places/:place_id/opening_hours/:id.json
  def destroy
    @opening_hour.destroy
    render partial:'list', locals:{place:@opening_hour.place}, layout:nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opening_hour
      if params[:id].present?
        @opening_hour = OpeningHour.find(params[:id])
      end
    end

    def set_place
      if params[:place_id].present?
        @place = Place.find(params[:place_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opening_hour_params
      params.require(:opening_hour).permit :id,
                                           :place_id,
                                           :day_of_week,
                                           shifts_attributes:[:id, :start_at, :end_at]
    end
end