class CartItemAdditionable < CartItem
  include Additionable

  belongs_to :product

  validates :product,
            presence: true

  validate :product_additionable?

  def product_additionable?
    if !self.product.type.additionable or self.product.type.sizable
      errors.add :product, 'has to be additionable! Cannot be sizable!'
    end
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

  def name
    self.product.name
  end

  def size
    nil
  end

  def product_price
    self.product.price
  end

  def quantity
    1
  end
end