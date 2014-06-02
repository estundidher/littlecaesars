class PickUpController < ApplicationController

  before_action :set_place, only: [:when, :times]

  # GET /pick_up
  def index
    @places = Place.order :name
  end

  # GET /pick_up/:place_id
  def when
    render partial:'pick_up/when', locals:{place:@place}, layout: nil
  end

  # GET /pick_up/:place_id/:date
  def times
    render partial:'pick_up/times', locals:{times_available:@place.times_available(Time.parse(params[:date]))}, layout: nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:place_id])
    end
end