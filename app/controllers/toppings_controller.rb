class ToppingsController < ApplicationController
  include CartConcern

  before_action :authenticate_customer!
  MAX_OF_THE_SAME_TOPPING = 2

  before_action :set_cart, only: [:index, :add_to_cart]
  before_action :set_product, only: [:index, :add, :add_to_cart]
  before_action :set_toppings, only: [:index, :add, :add_to_cart, :calculate]
  before_action :set_topping, only: [:add]
  before_action :set_cart_item, only: [:index, :add_to_cart]

  # POST /index
  def index
    @products = Product.not_additionable_nor_shoppable nil, @product.categories_of_toppings_available

    value = @toppings.nil? ? 0.0 : @toppings.sum(&:price)

    if params.has_key?(:cart_item_splittable) || params[:mode] == Cart::MODE[:two_flavours]
      @cart_item = (params[:side] == 'left' ? @cart_item.first_half : @cart_item.second_half)
      @toppings = @cart_item.additions
    end

    render partial:'toppings/modal', locals:{products:@products,
                                                  toppings:@toppings,
                                                  product:@product,
                                                  cart_item:@cart_item,
                                                  mode:params[:mode],
                                                  value:value,
                                                  side:params[:side]}, layout: nil
  end

  # POST /toppings/add
  def add

    unless @toppings.nil?
      if (@toppings+@product.items).select{|topping| topping.id == @topping.id}.size == MAX_OF_THE_SAME_TOPPING
        render plain:"Only #{MAX_OF_THE_SAME_TOPPING} of the same ingredient is permitted.", status: :unprocessable_entity
        return
      end
      if @toppings.size == max_additions(@product, params[:mode])
        render plain:'You have reached the maximum number of ingredients', status: :unprocessable_entity
        return
      end
    end
    render partial:'toppings/tag', locals:{product:@topping, type:'toppings'}, layout: nil
  end

  # POST /toppings/calculate
  def calculate
    total = @toppings.nil? ? 0.0 : @toppings.sum(&:price)
    render partial:'cart/price', locals:{value:total}, layout: nil
  end

  # POST /toppings
  def add_to_cart
    render partial:'cart/tags', locals:{products:@toppings,
                                         cart_item:@cart_item,
                                         side:params[:side],
                                         type:'additions'}, layout: nil
  end

  private

    def max_additions product, mode
      if mode == Cart::MODE[:one_flavour]
        product.type.max_additions
      else
        product.type.max_additions_per_half
      end
    end

    def set_toppings
      if params.has_key?(:cart_item_splittable)
        unless params[:cart_item_splittable][:addition_ids].nil?
          @toppings = params[:cart_item_splittable][:addition_ids].collect{|id| Product.find(id)}
        end
      elsif params.has_key?(:cart_item_sizable_additionable)
        unless params[:cart_item_sizable_additionable][:addition_ids].nil?
          @toppings = params[:cart_item_sizable_additionable][:addition_ids].collect{|id| Product.find(id)}
        end
      end
      unless params[:topping_ids].nil?
        @toppings = params[:topping_ids].collect{|id| Product.find(id)}
      end
    end

    def set_topping
      unless params[:topping_id].nil?
        @topping = Product.find params[:topping_id]
      end
    end
end