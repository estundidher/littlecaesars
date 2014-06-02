class PickUpController < ApplicationController

  before_action :set_place, only: [:when, :times]

  # GET /pick_up
  def index
    @places = Place.order :name
  end

  # GET /pick_up/:place_id
  def when

    dates_available = @place.dates_available
    first = dates_available.first
    times_available = @place.times_available(first)

    render partial:'pick_up/when', locals:{place:@place,
                                           dates_available:dates_available,
                                           times_available:times_available}, layout: nil
  end

  # GET /pick_up/:place_id/:date
  def times
    render partial:'pick_up/times', locals:{times_available:@place.times_available(Time.zone.parse(params[:date]))}, layout: nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:place_id])
    end
end