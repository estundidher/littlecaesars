class CheckoutController < ApplicationController
  include PickUpConfiguratedConcern
  include CartConcern

  before_action :authenticate_customer!

  before_action :set_cart, only: [:index, :new]

  before_action :pick_up_configurated?, only: [:new]

  # GET /cart/checkout/modal
  def index
    render partial:'modal', locals:{cart:@cart}, layout: nil
  end

  def new
    @years = (Time.current.year.to_i..(Time.current + 10.years).year.to_i).to_a
    @months = Date::MONTHNAMES.compact
  end

  def create
    render action: 'new'
  end

end