class Cart < ActiveRecord::Base

  enum status: [:open, :closed]

  belongs_to :customer

  has_many :items,
           dependent: :destroy,
           class_name: 'CartItem'

  def new_item product, params = nil
    if product.type.sizable?
      if params.nil?
        CartItemSizable.new cart:self
      else
        CartItemSizable.new params
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