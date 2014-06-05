module PickUpConfiguratedConcern
  extend ActiveSupport::Concern

  def pick_up_configurated?
    if customer_signed_in?
      @cart = Cart.current current_customer
      unless @cart.pick_up_configurated?
        redirect_to pick_up_index_path
      end
    end
    false
  end
end