class Admin::OvenTimeController < Admin::BaseController

  before_filter :cleanup_pagination_params

  def cleanup_pagination_params
    params[:id] = params[:id].to_i
    params[:time]  = params[:time].to_i
    params[:place_id]  = params[:place_id].to_i
  end
  
  # PATCH/PUT /oven_time/1
  # PATCH/PUT /oven_time/1.json
  def update
    
    respond_to do |format|
      @oven_time = OvenTime.find(params[:id])
      
      if @oven_time.update(oven_time_params)
        format.json { head :no_content }
      else
        format.json { render json: @oven_time.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def oven_time_params
      params.permit(:id, :time, :place_id)
    end
end