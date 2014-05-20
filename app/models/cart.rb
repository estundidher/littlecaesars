class Cart < ActiveRecord::Base

  enum status: [:open, :closed]

  belongs_to :customer

  has_many :items,
           dependent: :destroy,
           class_name: 'CartItem'

  def new_splittable_item first_half, second_half, size, params

    if params.nil?
      item = CartItemSplittable.new cart:self
      item.build_first_half
      item.first_half = self.new_item(first_half, size, params)

      item.build_second_half
      item.second_half = self.new_item(second_half, size, params)
      return item
    else
      CartItemSplittable.new params
    end
  end

  def new_item product, size, params

    if product.type.sizable? && product.type.additionable?
      if params.nil?
        item = CartItemSizableAdditionable.new cart:self
      else
        item = CartItemSizableAdditionable.new params
      end
      if item.price.nil?
        item.price = product.price_of(size)
      end
      item
    elsif product.type.sizable?
      if params.nil?
        item = CartItemSizable.new cart:self
      else
        item = CartItemSizable.new params
      end
      if item.price.nil?
        item.price = product.price_of(size)
      end
      item
    elsif product.type.additionable?
      if params.nil?
        CartItemAdditionable.new cart:self, product: product
      else
        CartItemAdditionable.new params
      end
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