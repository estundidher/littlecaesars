class CartItemSizableAdditionable < CartItem
  include Additionable

  belongs_to :price

  validates :price,
            presence: true

  validate :product_sizable?,
           :product_additionable?

  def product_sizable?
    unless self.price.product.type.sizable?
      errors.add :product, 'has to be sizable!'
    end
  end

  def product_additionable?
    if !self.price.product.type.additionable
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
    self.price.value
  end

  def name
    self.price.product.name
  end

  def photo
    self.price.product.photo
  end

  def sizable?
    true
  end

  def size
    price.size
  end

  def quantity
    1
  end
end