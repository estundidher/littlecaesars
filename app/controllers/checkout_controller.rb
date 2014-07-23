class CheckoutController < ApplicationController
  include PickUpConfiguratedConcern
  include CartConcern

  before_action :authenticate_customer!

  before_action :set_cart, only: [:modal]

  before_action :pick_up_configurated?, only: [:modal]

  # GET /checkout
  def modal
    render partial:'modal', locals:{cart:@cart}, layout:nil
  end
end