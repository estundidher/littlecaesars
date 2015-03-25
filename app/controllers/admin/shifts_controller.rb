class Admin::ShiftsController < Admin::BaseController

  before_action :set_shift, only: [:destroy]
  before_action :set_opening_hour, only: [:new]

  # POST places/1/opening_hours/1/shift/new
  def new
    if @opening_hour.nil?
      @opening_hour = OpeningHour.new(opening_hour_params)
    end
    @opening_hour.shifts.build
    render partial:'shift', locals:{opening_hour: @opening_hour,
                                    shift: @opening_hour.shifts.last}, layout: nil
  end

  # DELETE places/1/opening_hours/1/shift/:id
  def destroy
    @shift.destroy
    render nothing:true, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opening_hour
      if params[:id].present?
        @opening_hour = OpeningHour.find(params[:id])
      end
    end

    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opening_hour_params
      params.require(:opening_hour).permit :id,
                                           :place_id,
                                           :day_of_week,
                                           shifts_attributes:[:id, :start_at, :end_at]
    end
end