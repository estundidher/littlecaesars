class CheckoutController < ApplicationController
  include CartConcern

  before_action :authenticate_customer!

  before_action :set_cart, only: [:index, :new]

  # GET /cart/checkout/modal
  def index
    render partial:'modal', locals:{cart:@cart}, layout: nil
  end

end