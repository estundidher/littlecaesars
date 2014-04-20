class CartController < ApplicationController

  # GET /cart/add/1
  def modal
    @product = Product.find(params[:id])
    render 'modal', layout: nil
  end

  def add
    @product = Product.find(params[:id])

    #render layout: nil
    head :no_content, status: :ok
  end

end