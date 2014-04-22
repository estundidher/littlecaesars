class HomeController < ApplicationController

  before_action :set_products, only: [:product]

  def shopping
  end

  def product
  end

  def contact
  end

  def pick_up
  end

private
    # Use callbacks to share common setup or constraints between actions.
  def set_products
    @product = Product.find(params[:id])
  end
end