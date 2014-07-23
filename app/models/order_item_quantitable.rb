class OrderItemQuantitable < OrderItem

  belongs_to :product

  validates :product,
            presence: true

  validates :quantity,
            presence: true

  validate :product_quantitable?

  def self.create order, cart_item
    OrderItemSizable.new order:order,
                       product:cart_item.product,
                  product_name:cart_item.product.name,
                      quantity:cart_item.quantity
                    unit_price:cart_item.product.price,
                         price:cart_item.total
  end

  def product_quantitable?
    unless self.product.type.quantitable?
      errors.add :product, 'has to be quantitable!'
    end
  end

  def additionable?
    false
  end

  def quantitable?
    true
  end

  def sizable?
    false
  end
end