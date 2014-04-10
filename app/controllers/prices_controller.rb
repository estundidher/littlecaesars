class PricesController < ApplicationController

before_action :set_prices, only: [:show, :edit, :update, :destroy]

  # GET /modal
  def modal
    @price = Price.new
    @price.dish_id = params[:dish_id]
    render layout: 'ajax'
  end

#  def save
#    @dish = Dish.find(params[:id])
#    @price = @dish.prices.build(:size => Size.find(params[:size]), :value => params[:price])
#    @price.save
#    render "prices"
#  end

#  def delete
#    @dish = Dish.find(params[:id])
#    @price = @dish.prices.build(:size => Size.find(params[:size]), :value => params[:price])
#    @price.save
#    render "prices"
#  end

  # GET /prices
  # GET /prices.json
  def index
    respond_to do |format|
      format.html { @prices = Price.all }
      format.json { @prices = Price.order(:name) }
    end
  end

  # GET /prices
  # GET /prices.json
  def list
    @prices = Price.all
  end

  # GET /prices/1
  # GET /prices/1.json
  def show
  end

  # GET /prices/new
  def new
    @price = Price.new
  end

  # GET /prices/1/edit
  def edit
    render 'modal', layout: 'ajax'
  end

  # POST /prices
  def create
    @price = Price.new(price_params)
    if @price.save
      render partial: 'list', locals: {dish:@price.dish}
    else
      render partial: 'form', locals: {price:@price}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prices/1
  # PATCH/PUT /prices/1.json
  def update
    if @price.update(price_params)
      render partial: 'list', locals: {dish:@price.dish}
    else
      render partial: 'form', locals: {price:@price}, status: :unprocessable_entity
    end
  end

  # DELETE /prices/1
  # DELETE /prices/1.json
  def destroy
    @price.destroy
    render partial: 'list', locals: {dish:@price.dish}
  end

  def update_prices
    @prices = Price.where(price_id:nil).order(:name).map{|s| [s.name, s.id]}.insert(0, "")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prices
      @price = Price.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.require(:price).permit(:dish_id, :size_id, :value)
    end
end