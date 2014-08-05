class OrderItemSizable < OrderItem

  belongs_to :product

  belongs_to :size

  validates :price,
            presence: true

  validates :product,
            presence: true

  validates :product_name,
            presence: true

  validates :size,
            presence: true

  validates :size_name,
            presence: true

  def second_half
    nil
  end

  def first_half
    nil
  end

  def self.create order, cart_item

    OrderItemSizable.new order:order,
                       product:cart_item.price.product,
                  product_name:cart_item.price.product.name,
                          size:cart_item.price.size,
                     size_name:cart_item.price.size.name,
                    unit_price:cart_item.price.value,
                         price:cart_item.total
  end

  def additionable?
    false
  end

  def quantitable?
    false
  end

  def sizable?
    true
  end

  def quantity
    1
  end
end