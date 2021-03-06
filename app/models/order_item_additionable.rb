class OrderItemAdditionable < OrderItem
  include OrderItemProductAdditionable

  belongs_to :product

  validates :product,
            presence: true

  validates :product_name,
            presence: true

  validates :price,
            presence: true

  validate :product_additionable?

  def self.create order, cart_item

    return OrderItemAdditionable.new order:order,
                                   product:cart_item.product,
                              product_name:cart_item.product.name,
                                unit_price:cart_item.price,
                                     price:cart_item.total,
                                 additions:cart_item.additions,
                              subtractions:cart_item.subtractions
  end

  def product_additionable?
    if !self.product.type.additionable or self.product.type.sizable
      errors.add :product, 'has to be additionable! Cannot be sizable!'
    end
  end

  def second_half
    nil
  end

  def first_half
    nil
  end

  def additionable?
    true
  end

  def quantitable?
    false
  end

  def sizable?
    false
  end

  def photo
    self.product.photo
  end

  def size
    nil
  end

  def quantity
    1
  end
end