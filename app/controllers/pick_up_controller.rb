class PickUpController < ApplicationController

  before_action :set_place, only: [:when]

  # GET /pick_up
  def index
    @places = Place.order :name
  end

  # GET /pick_up/when
  def when
    render partial: 'pick_up/when', locals:{place:@place}, layout: nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end
end