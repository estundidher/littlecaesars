class PickUpController < ApplicationController

  #devise configuration
  before_action :authenticate_customer!

  before_action :set_place, only: [:new, :dates]

  before_action :set_cart, only: [:create, :index]

  # GET /pick_up/index
  def index

    unless @cart.pick_up.nil?
      @order = Order.current current_customer
      if @order.present?
        @order.destroy
      end
      @cart.pick_up.destroy
    end

    @places = Place.order :name
  end

  # GET /pick_up/new
  def new
    @pick_up = PickUp.new place:@place

    render partial:'pick_up/new', locals:{pick_up:@pick_up,
                                          place:@place,
                                          dates_available:@place.dates_available,
                                          times_available:@place.first_times_available}, layout: nil
  end

  # GET /pick_up/:place_id/:date
  def dates
    render partial:'pick_up/dates', locals:{times_available:@place.times_available(Time.zone.parse(params[:date]))}, layout: nil
  end

  # POST /pick_up
  def create

    @pick_up = @cart.build_pick_up pick_up_params

    if @pick_up.save
      render plain: shopping_url, status: :ok
    else
      render partial:'pick_up/new', locals:{pick_up:@pick_up,
                                            place:@pick_up.place,
                                            dates_available:@pick_up.place.dates_available,
                                            times_available:@pick_up.place.first_times_available}, layout: nil, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:place_id])
    end

    def set_cart
      @cart = Cart.current current_customer
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pick_up_params
      params.require(:pick_up).permit :place_id,
                                      :cart_id,
                                      :date
    end
end