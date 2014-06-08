module CartConcern
  extend ActiveSupport::Concern

  private

    def set_cart
      if params[:cart_id].nil?
        @cart = Cart.current current_customer
      else
        @cart = Cart.find(params[:cart_id])
      end
    end

    def set_cart_item
      if params[:id].nil?
        if params.has_key?(:cart_item_splittable) || params[:mode] == Cart::MODE[:two_flavours]
          @cart_item = @cart.new_splittable_item @product, @product, @size, cart_item_params
        elsif params[:mode].nil? || params[:mode] == Cart::MODE[:one_flavour]
          @cart_item = @cart.new_item @product, @size, cart_item_params
        end
      else
        @cart_item = CartItem.find(params[:id])
      end
    end

    def set_product
      unless params[:product_id].nil? or params[:product_id].empty?
        @product = Product.find params[:product_id]
      end
      unless cart_item_params.nil?
        unless cart_item_params[:product_id].nil?
          @product = Product.find cart_item_params[:product_id]
        end
      end
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

      elsif params.has_key?(:cart_item_additionable)
        params.require(:cart_item_additionable).permit :cart_id,
                                                       :notes,
                                                       :product_id,
                                                       :addition_ids => [],
                                                       :subtraction_ids => []

      elsif params.has_key?(:cart_item_sizable_additionable)
        params.require(:cart_item_sizable_additionable).permit :price_id,
                                                               :cart_id,
                                                               :notes,
                                                               :addition_ids => [],
                                                               :subtraction_ids => []
      elsif params.has_key?(:cart_item_splittable)
        params.require(:cart_item_splittable).permit :cart_id,
                                                     :notes,
                                                     first_half_attributes: [:price_id,
                                                                             :cart_id,
                                                                             :addition_ids => [],
                                                                             :subtraction_ids => []],
                                                    second_half_attributes: [:price_id,
                                                                             :cart_id,
                                                                             :addition_ids => [],
                                                                             :subtraction_ids => []]
      end
    end
end