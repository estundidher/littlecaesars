class CartController < ApplicationController

  before_action :set_cart, only: [:modal, :checkout, :create, :calculate, :index]
  before_action :set_cart_item, only: [:destroy]
  before_action :set_product, only: [:modal, :calculate, :create, :index, :items, :mode, :add_additionable]
  before_action :set_category, only: [:splitter, :slider]
  before_action :set_size, only: [:splitter, :slider, :mode]

  # GET /cart/add/1
  def modal
    @cart_item = @cart.new_item @product
    render partial: 'cart/modal/modal', locals:{cart_item:@cart_item, product:@product}, layout: nil
  end

  # POST /cart/calculate
  def calculate
    @cart_item = @cart.new_item @product, cart_item_params
    render partial:'cart/price', locals:{value:@cart_item.total}, layout: nil
  end

  # POST /cart/add/1
  def create
    @cart_item = @cart.new_item @product, cart_item_params
    if @cart_item.save
      render partial:'cart/button/cart', locals:{cart:@cart_item.cart}, layout: nil
    else
      render partial:'cart/modal/form', locals:{cart_item:@cart_item, product:@product}, layout:nil, status: :unprocessable_entity
    end
  end

  # DELETE /cart/1
  def destroy
    if @cart_item.destroy
      render partial:'cart/button/cart', locals:{cart:@cart_item.cart}, layout: nil
    else
      render partial:'cart/button/cart', locals:{cart:@cart_item.cart}, layout: nil, status: :unprocessable_entity
    end
  end

  # GET /cart/checkout
  def checkout
    render partial:'cart/checkout/modal', locals:{cart:@cart}, layout: nil
  end

  # GET /cart
  def index
    @cart_item = CartItemSizableAdditionable.new cart:@cart
    @categories = Category.with_shoppable_products
    if @product.nil?
      @category = @categories.first
    else
      @category = @product.category
    end
    @products = @category.products.shoppable_additionable
    if @product.nil?
      @product = @products.first
    end
    @sizes = Size.order :name
    render layout:'generic'
  end

  # GET /cart/splitter/:side/:category_id
  def splitter
    @products = @category.products.shoppable_additionable_splittable @size, nil
    @categories = Category.with_shoppable_products
    render partial:'splitter_side', locals:{side:params[:side], size:@size, category:@category, categories:@categories, products:@products, product:@products.first}, layout: nil
  end

  # GET /cart/slider/:category_id
  def slider
    @products = @category.products.shoppable_additionable @size, nil
    render partial:'slider_internal', locals:{products:@products, size:@size, product:@products.first, category:@category}, layout: nil
  end

  # GET /cart/:product_id/items
  def items
    render partial:'additions', locals:{product:@product}, layout: nil
  end

  # GET /cart/toppings
  def toppings
    @products = Product.not_additionable_nor_shoppable
    render partial:'cart/toppings/modal', locals:{products:@products}, layout: nil
  end

  # POST /cart/toppings/add/product_id
  def add_topping
    products = Product.where(id:params[:product_ids]).order :name
    render partial:'cart/toppings/added', locals:{products:products}, layout: nil
  end

  # POST /cart/toppings/calculate
  def toppings_calculate
    total = Product.find(params[:product_ids]).sum(&:price)
    render partial:'cart/price', locals:{value:total}, layout: nil
  end

  # POST /cart/mode
  def mode
    @categories = Category.with_shoppable_products
    if @product.nil?
      @category = @categories.first
    else
      @category = @product.category
    end
    if params[:mode] == 'slider'
      @products = @category.products.shoppable_additionable @size, nil
    elsif params[:mode] == 'splitter'
      @products = @category.products.shoppable_additionable_splittable @size, nil
    end
    if @product.nil? || @products.exclude?(@product)
      @product = @products.first
    end
    render partial:'chooser', locals:{mode:params[:mode],
                                      category:@category,
                                      size:@size,
                                      product:@product,
                                      categories:@categories,
                                      products:@products}, layout: nil
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    if params[:cart_id].nil?
      @cart = Cart.find_or_create_by(customer: current_customer, status: Cart.statuses[:open])
    else
      @cart = Cart.find(params[:cart_id])
    end
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def set_product
    unless params[:product_id].nil?
      @product = Product.find params[:product_id]
    end
    unless cart_item_params.nil?
      unless cart_item_params[:product_id].nil?
        @product = Product.find cart_item_params[:product_id]
      end
    end
  end

  def set_category
    unless params[:category_id].nil?
      @category = Category.find params[:category_id]
    end
  end

  def set_size
    unless params[:size_id].nil?
      if params[:size_id] != ""
        @size = Size.find params[:size_id]
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

    elsif params.has_key?(:cart_item_sizable_additionable)

      params.require(:cart_item_sizable_additionable).permit :product_id,
                                                             :price_id,
                                                             :cart_id,
                                                             :notes,
                                                             :addition_ids => []
    end
  end
end