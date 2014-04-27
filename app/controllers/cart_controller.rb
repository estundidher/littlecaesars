class CartController < ApplicationController

  before_action :set_cart, only: [:add, :checkout, :create]
  before_action :set_cart_item, only: [:destroy]

  # GET /cart/add/1
  def add
    @product = Product.find params[:product_id]
    @cart_item = @cart.new_item @product
    render partial: 'add_modal', locals:{cart_item:@cart_item, product: @product}, layout: nil
  end

  # POST /cart/add/1
  def create
    @product = Product.find cart_item_params[:product_id]
    @cart_item = @cart.new_item @product, cart_item_params
    if @cart_item.save
      render partial:'cart', locals:{cart:@cart_item.cart}, layout: nil
    else
      render partial:'form', locals:{cart_item:@cart_item, product: @product}, layout: nil, status: :unprocessable_entity
    end
  end

  # DELETE /cart/1
  def destroy
    if @cart_item.destroy
      render partial:'cart', locals:{cart:@cart_item.cart}, layout: nil
    else
      render partial:'cart', locals:{cart:@cart_item.cart}, layout: nil, status: :unprocessable_entity
    end
  end

  # GET /cart/checkout
  def checkout
    render partial:'checkout_modal', locals:{cart:@cart}, layout: nil
  end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      if params[:id].nil?
        @cart = Cart.find_or_create_by(customer: current_customer, status: Cart.statuses[:open])
      else
        @cart = Cart.find(params[:id])
      end
    end

    def set_cart_item
      @cart_item = CartItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_item_params

      if params.has_key?(:cart_item_sizable)

        params.require(:cart_item_sizable).permit :product_id,
                                                  :price_id,
                                                  :cart_id,
                                                  :notes

      elsif params.has_key?(:cart_item_quantitable)

        params.require(:cart_item_quantitable).permit :product_id,
                                                      :quantity,
                                                      :cart_id,
                                                      :notes
      end
    end
end