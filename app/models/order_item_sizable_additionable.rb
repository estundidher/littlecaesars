class OrderItemSizableAdditionable < OrderItem
  include OrderItemProductAdditionable

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

  validate :product_sizable?,
           :product_additionable?

  def self.create order, cart_item
    OrderItemSizableAdditionable.new order:order,
                                   product:cart_item.price.product,
                              product_name:cart_item.price.product.name,
                                      size:cart_item.price.size,
                                 size_name:cart_item.price.size.name,
                                unit_price:cart_item.price.value,
                                     price:cart_item.total,
                                 additions:cart_item.additions,
                              subtractions:cart_item.subtractions
  end

  def product_sizable?
    unless self.product.type.sizable?
      errors.add :product, 'has to be sizable!'
    end
  end

  def product_additionable?
    if !self.product.type.additionable
      errors.add :product, 'has to be additionable!'
    end
  end

  def quantitable?
    false
  end

  def additionable?
    true
  end

  def product_price
    self.price
  end

  def photo
    self.product.photo
  end

  def sizable?
    true
  end

  def quantity
    1
  end
end