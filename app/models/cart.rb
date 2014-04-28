class Cart < ActiveRecord::Base

  enum status: [:open, :closed]

  belongs_to :customer

  has_many :items,
           dependent: :destroy,
           class_name: 'CartItem'

  def new_item product, params = nil

    if product.type.sizable? && product.type.additionable?
      if params.nil?
        item = CartItemSizableAdditionable.new cart:self
      else
        item = CartItemSizableAdditionable.new params
      end
      if item.price.nil?
        item.price = product.prices.first
      end
      item
    elsif product.type.sizable?
      if params.nil?
        item = CartItemSizable.new cart:self
      else
        item = CartItemSizable.new params
      end
      if item.price.nil?
        item.price = product.prices.first
      end
      item
    elsif product.type.quantitable?
      if params.nil?
        CartItemQuantitable.new cart:self, product: product
      else
        CartItemQuantitable.new params
      end
    end
  end

  def total
    self.items.inject(0) {|sum, item| sum + item.total}
  end
end