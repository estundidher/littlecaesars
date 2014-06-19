class CartController < ApplicationController
  include PickUpConfiguratedConcern
  include CartConcern

  #devise configuration
  before_action :authenticate_customer!

  before_action :set_cart, only: [:modal, :create, :calculate, :index, :mode, :price, :ingredients]
  before_action :set_product, only: [:modal, :calculate, :create, :index, :ingredients, :mode]
  before_action :set_category, only: [:carousel, :mode]
  before_action :set_size, only: [:carousel, :mode]
  before_action :set_cart_item, only: [:destroy, :ingredients, :calculate, :create, :modal]

  before_action :pick_up_configurated?, only: [:index]

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

  # POST /cart/mode
  def mode
    @categories = Category.with_shoppable_products
    if params[:mode] == Cart::MODE[:one_flavour]
      @products = @category.products.shoppable nil, nil, @size, nil
    elsif params[:mode] == Cart::MODE[:two_flavours]
      @products = @category.products.shoppable_splittable @size, nil
    end
    unless @products.nil?
      if @product.nil? || @products.exclude?(@product)
        @product = @products.first
      end
    end

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
end