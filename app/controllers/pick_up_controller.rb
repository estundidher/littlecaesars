class PickUpController < ApplicationController

  before_action :set_place, only: [:new, :times]

  before_action :set_cart, only: [:create]

  #devise configuration
  before_action :authenticate_customer!

  # GET /pick_up/index
  def index
    @places = Place.order :name
  end

  # GET /pick_up/new
  def new
    dates_available = @place.dates_available
    first = dates_available.first
    times_available = @place.times_available(first)

    @pick_up = PickUp.new place:@place

    render partial:'pick_up/new', locals:{pick_up:@pick_up,
                                          place:@place,
                                          dates_available:dates_available,
                                          times_available:times_available}, layout: nil
  end

  # GET /pick_up/:place_id/:date
  def dates
    render partial:'pick_up/dates', locals:{times_available:@place.times_available(Time.zone.parse(params[:date]))}, layout: nil
  end

  # POST /pick_up
  def create
    if @cart.pick_up.nil?
      @cart.create_pick_up(pick_up_params)
    else
      @cart.pick_up.update_attributes(pick_up_params)
    end
    redirect_to order_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:place_id])
    end

    def set_cart
      @cart = Cart.current(current_customer)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pick_up_params
      params.require(:pick_up).permit :place_id,
                                      :cart_id,
                                      :date
    end
end