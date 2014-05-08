class CartController < ApplicationController

  before_action :set_cart, only: [:modal, :checkout, :create, :calculate, :index]
  before_action :set_cart_item, only: [:destroy]
  before_action :set_product, only: [:modal, :calculate, :create, :index, :items, :mode]
  before_action :set_category, only: [:splitter, :slider]

  # GET /cart/add/1
  def modal
    @cart_item = @cart.new_item @product
    render partial: 'cart/modal/modal', locals:{cart_item:@cart_item, product:@product}, layout: nil
  end

  # POST /cart/calculate
  def calculate
    @cart_item = @cart.new_item @product, cart_item_params
    render partial:'cart/modal/form_price', locals:{cart_item:@cart_item}, layout: nil
  end

  # POST /cart/add/1
  def create
    @cart_item = @cart.new_item @product, cart_item_params
    if @cart_item.save
      render partial:'cart/top/cart', locals:{cart:@cart_item.cart}, layout: nil
    else
      render partial:'cart/modal/form', locals:{cart_item:@cart_item, product:@product}, layout:nil, status: :unprocessable_entity
    end
  end

  # DELETE /cart/1
  def destroy
    if @cart_item.destroy
      render partial:'cart/top/cart', locals:{cart:@cart_item.cart}, layout: nil
    else
      render partial:'cart/top/cart', locals:{cart:@cart_item.cart}, layout: nil, status: :unprocessable_entity
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
    @products = @category.products.shoppable_additionable_splittable
    if @product.nil?
      @product = @products.first
    end
    @sizes = Size.order :name
    render layout:'generic'
  end

  # GET /cart/splitter/:side/:category_id
  def splitter
    @products = @category.products.shoppable_additionable
    @categories = Category.with_shoppable_products
    render partial:'splitter_side', locals:{side:params[:side], category:@category, categories:@categories, products:@products, product:@products.first}, layout: nil
  end

  # GET /cart/slider/:category_id
  def slider
    @products = @category.products.shoppable_additionable
    render partial:'slider_internal', locals:{products:@products, product:@products.first, category:@category}, layout: nil
  end

  # GET /cart/:product_id/items
  def items
    render partial:'additions', locals:{product:@product}, layout: nil
  end

  # POST /cart/mode
  def mode
    @categories = Category.with_shoppable_products
    if @product.nil?
      @category = @categories.first
    else
      @category = @product.category
    end
    @products = @category.products.shoppable_additionable_splittable
    if @product.nil?
      @product = @products.first
    end
    render partial:'chooser', locals:{products:@products, product:@product, category:@category, categories:@categories, mode:params[:mode]}, layout: nil
  end

  # GET /cart/:mode/sizes
  def sizes
    sizes = params[:mode] == 'splitter' ? Size.where(splittable:true).order(:name) : Size.order(:name)
    render partial:'sizes', locals:{sizes:sizes}, layout: nil
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