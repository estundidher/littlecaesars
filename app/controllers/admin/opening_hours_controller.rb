class Admin::OpeningHoursController < ApplicationController

  before_action :set_opening_hour, only: [:edit, :update, :destroy]

  # GET /:place_id/opening_hours/new
  def new
    @opening_hour = OpeningHour.new
    @opening_hour.shifts.build
    @opening_hour.place_id = params[:place_id]
    render 'modal', layout: nil
  end

  # GET /opening_hours/1/edit
  def edit
    render 'modal', layout: nil
  end

  # GET /opening_hours/shift/add
  def add_shift
    if params[:id].present?
      set_opening_hour()
    end
    render partial:'shift', :locals => {shift: Shift.new(opening_hour: @opening_hour), shift_index: params[:shifts].to_i}, layout: nil
  end

  # DELETE /opening_hours/shift/:id
  def destroy_shift
    Shift.find(params[:id]).destroy
    head :no_content, status: :ok
  end

  # POST /opening_hours
  def create
    @opening_hour = OpeningHour.new(opening_hour_params)
    if @opening_hour.save
      render partial:'list', locals: {place:@opening_hour.place}, layout: nil
    else
      render partial:'form', locals: {opening_hour:@opening_hour}, layout: nil, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /opening_hours/1
  # PATCH/PUT /opening_hours/1.json
  def update
    @opening_hour.shifts.destroy_all
    if @opening_hour.update(opening_hour_params)
      render partial:'list', locals: {place:@opening_hour.place}, layout: nil
    else
      render partial:'form', locals: {opening_hour:@opening_hour}, layout: nil, status: :unprocessable_entity
    end
  end

  # DELETE /opening_hours/1
  # DELETE /opening_hours/1.json
  def destroy
    @opening_hour.destroy
    render partial:'list', locals: {place:@opening_hour.place}, layout: nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opening_hour
      @opening_hour = OpeningHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opening_hour_params
      params.require(:opening_hour).permit :place_id,
                                           :day_of_week,
                                           :shifts_attributes => [:id, :start_at, :end_at]
    end
end