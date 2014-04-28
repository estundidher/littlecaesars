class CartItemQuantitable < CartItem

  belongs_to :product

  validates :product,
            presence: true

  validates :quantity,
            presence: true

  validate :product_quantitable?

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

  def total
    self.product.price * (self.quantity || 1)
  end

  def name
    self.product.name
  end

  def photo
    self.product.photo
  end

  def sizable?
    false
  end
end