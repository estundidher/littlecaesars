class HomeController < ApplicationController

  before_action :set_product, only: [:product]
  before_action :set_category, only: [:category]

  def index
    render layout:'generic'
  end

  def shopping

  end

  def category
  end

  def product
  end

  def contact
  end

  def pick_up
  end

  def about
  end

  def menu
  end

private
    # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end
  def set_category
    @category = Category.find(params[:id])
  end
end