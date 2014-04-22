class CartItemSizableAdditionable < CartItem

  belongs_to :price

  validates :price,
            presence: true

  has_many :additions

  validate :product_sizable?,
           :product_additionable?

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
end