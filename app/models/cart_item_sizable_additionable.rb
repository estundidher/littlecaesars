class CartItemSizableAdditionable < CartItem

  belongs_to :price

  validates :price,
            presence: true

  has_and_belongs_to_many :additions,
                          class_name: 'Product',
                          foreign_key: :cart_item_id,
                          joing_table: 'cart_item_products'

  has_and_belongs_to_many :subtractions,
                          class_name: 'Product',
                          foreign_key: :cart_item_id,
                          joing_table: 'cart_item_subtractions'

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

  def total
    if self.additions
      self.price.value + self.additions.inject(0) {|sum, addition| sum + addition.price}
    else
      self.price.value
    end
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