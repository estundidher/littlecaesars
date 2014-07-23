class CartItemQuantitable < CartItem

  belongs_to :product

  validates :product,
            presence: true

  validates :quantity,
            presence: true

  validates :price,
            presence: true

  validates :unit_price,
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

  def photo
    self.product.photo
  end

  def sizable?
    false
  end
end