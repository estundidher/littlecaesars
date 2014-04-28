class CartItemAdditionable < CartItem

  belongs_to :product

  has_many :additions

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
end