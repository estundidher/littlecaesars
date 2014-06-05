class CartController < ApplicationController
  include PickUpConfiguratedConcern

  CART_MODE = {:one_flavour=>'one-flavour', :two_flavours=>'two-flavours'}
  MAX_OF_THE_SAME_TOPPING = 2

  #devise configuration
  before_action :authenticate_customer!

  before_action :set_cart, only: [:modal, :checkout, :create, :calculate, :index, :toppings, :mode, :price, :ingredients, :add_toppings]
  before_action :set_product, only: [:modal, :calculate, :create, :index, :ingredients, :mode, :add_topping, :toppings, :add_toppings]
  before_action :set_category, only: [:carousel, :mode]
  before_action :set_size, only: [:carousel, :mode]
  before_action :set_toppings, only: [:toppings, :add_toppings, :toppings_calculate, :add_topping]
  before_action :set_topping, only: [:add_topping]
  before_action :set_cart_item, only: [:destroy, :ingredients, :calculate, :create, :toppings, :add_toppings, :modal]

  before_action :pick_up_configurated?, only: [:index]

  def update
    redirect_to order_path
  end

  # GET /cart/add/1
  def modal
    render partial: 'cart/modal/modal', locals:{cart_item:@cart_item, product:@product}, layout: nil
  end

  # POST /cart/calculate
  def calculate
    render partial:'cart/price', locals:{value:@cart_item.total}, layout: nil
  end

  # POST /cart/price
  def price
    render partial:'cart/button/price', locals:{cart:@cart}, layout: nil
  end

  # POST /cart/add/1
  def create
    if @cart_item.save
      render partial:'cart/button/item', locals:{cart_item:@cart_item}, layout: nil
    else
      render partial:'layouts/form_errors', locals:{model:@cart_item},
                                            layout:nil, status: :unprocessable_entity
    end
  end

  # DELETE /cart/1
  def destroy
    if @cart_item.destroy
      render partial:'cart/button/price', locals:{cart:@cart_item.cart}, layout: nil
    else
      render partial:'cart/button/price', locals:{cart:@cart_item.cart},
                                          layout: nil, status: :unprocessable_entity
    end
  end

  # GET /cart/checkout
  def checkout
    render partial:'cart/checkout/modal', locals:{cart:@cart}, layout: nil
  end

  # GET /cart
  def index
    @categories = Category.with_shoppable_products
    if @product.nil?
      @category = @categories.first
    else
      @category = @product.categories.first
    end
    @products = @category.products.shoppable
    if @product.nil?
      @product = @products.first
    end
    @sizes = @products.map{|p| p.sizes}.flatten.uniq
    @size = @sizes.first
    set_cart_item()
    render layout:'generic'
  end

  # GET /cart/:product_id/mode/ingredients
  def ingredients
    render partial:'cart/ingredients', locals:{product:@product,
                                              side:params[:side],
                                              cart_item:@cart_item}, layout: nil
  end

  # POST /cart/toppings/open
  def toppings
    @products = Product.not_additionable_nor_shoppable nil, @product.categories_of_toppings_available

    value = @toppings.nil? ? 0.0 : @toppings.sum(&:price)

    if params.has_key?(:cart_item_splittable) || params[:mode] == CART_MODE[:two_flavours]
      @cart_item = (params[:side] == 'left' ? @cart_item.first_half : @cart_item.second_half)
      @toppings = @cart_item.additions
    end

    render partial:'cart/toppings/modal', locals:{products:@products,
                                                  toppings:@toppings,
                                                  product:@product,
                                                  cart_item:@cart_item,
                                                  mode:params[:mode],
                                                  value:value,
                                                  side:params[:side]}, layout: nil
  end

  # POST /cart/toppings/add
  def add_topping

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
    render partial:'cart/toppings/tag', locals:{product:@topping, type:'toppings'}, layout: nil
  end

  def max_additions product, mode
    if mode == CART_MODE[:one_flavour]
      product.type.max_additions
    else
      product.type.max_additions_per_half
    end
  end

  # POST /cart/toppings
  def add_toppings
    render partial:'cart/tags', locals:{products:@toppings,
                                         cart_item:@cart_item,
                                         side:params[:side],
                                         type:'additions'}, layout: nil
  end

  # POST /cart/toppings/calculate
  def toppings_calculate
    total = @toppings.nil? ? 0.0 : @toppings.sum(&:price)
    render partial:'cart/price', locals:{value:total}, layout: nil
  end

  # POST /cart/mode
  def mode
    @categories = Category.with_shoppable_products
    if params[:mode] == CART_MODE[:one_flavour]
      @products = @category.products.shoppable nil, nil, @size, nil
    elsif params[:mode] == CART_MODE[:two_flavours]
      @products = @category.products.shoppable_splittable @size, nil
    end
    unless @products.nil?
      if @product.nil? || @products.exclude?(@product)
        @product = @products.first
      end
    end

    #puts "#{'#'*100}> mode: #{params[:mode]}, @products: #{@products.size()}, @product: #{@product}"

    @sizes = @products.map{|p| p.sizes}.flatten.uniq
    @size = @sizes.first if @size.nil?

    set_cart_item()

    render partial:'cart/chooser', locals:{mode:params[:mode],
                                          cart_item:@cart_item,
                                          category:@category,
                                          size:@size,
                                          sizes:@sizes,
                                          product:@product,
                                          categories:@categories,
                                          products:@products}, layout: nil
  end

  # GET /cart/:mode/:category_id/:side/:size
  def carousel
    @products = @category.products.shoppable nil, nil, @size, nil
    render partial:'cart/carousel', locals:{products:@products,
                                            size:@size,
                                            side:(params[:side] || 'left'),
                                            mode:params[:mode],
                                            product:@products.first,
                                            category:@category}, layout: nil
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart_item
    if params[:id].nil?
      if params.has_key?(:cart_item_splittable) || params[:mode] == CART_MODE[:two_flavours]
        @cart_item = @cart.new_splittable_item @product, @product, @size, cart_item_params
      elsif params[:mode].nil? || params[:mode] == CART_MODE[:one_flavour]
        @cart_item = @cart.new_item @product, @size, cart_item_params
      end
    else
      @cart_item = CartItem.find(params[:id])
    end
  end

  def set_cart
    if params[:cart_id].nil?
      @cart = Cart.current current_customer
    else
      @cart = Cart.find(params[:cart_id])
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

  def set_category
    unless params[:category_id].nil?
      @category = Category.find params[:category_id]
    end
  end

  def set_size
    unless params[:size_id].nil? or params[:size_id].empty?
      @size = Size.find params[:size_id]
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