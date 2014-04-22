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
end