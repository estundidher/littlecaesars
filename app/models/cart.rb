class Cart < ActiveRecord::Base

  enum status: [:open, :closed]

  belongs_to :customer

  has_many :items,
           dependent: :destroy,
           class_name: 'CartItem'

  def newItem product
    if product.type.sizable?
        CartItemSizable.new cart:self
    end
  end

  def total
    self.items.inject(0) {|sum, item| sum + item.total}
  end
end