class Admin::PricesController < ApplicationController

  before_action :set_prices, only: [:edit, :update, :destroy]

  # GET /product/:product_id/prices/new
  def new
    @price = Price.new
    @price.product_id = params[:product_id]
    render 'modal', layout: nil
  end

  # GET /prices/1/edit
  def edit
    render 'modal', layout: nil
  end

  # POST /prices
  def create
    @price = Price.new(price_params)
    if @price.save!
      render partial: 'list', locals: {product:@price.product}, layout: nil
    else
      render partial: 'form', locals: {price:@price}, layout: nil, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prices/1
  # PATCH/PUT /prices/1.json
  def update
    if @price.update!(price_params)
      render partial: 'list', locals: {product:@price.product}, layout: nil
    else
      render partial: 'form', locals: {price:@price}, layout: nil, status: :unprocessable_entity
    end
  end

  # DELETE /prices/1
  # DELETE /prices/1.json
  def destroy
    @price.destroy!
    render partial: 'list', layout: nil, locals: {product:@price.product}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prices
      @price = Price.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.require(:price).permit :product_id, :size_id, :value
    end
end