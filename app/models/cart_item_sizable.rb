class CartItemSizable < CartItem

  belongs_to :price

  validates :price,
            presence: true

  def total
    self.price.value
  end

  def name
    self.price.product.name
  end

  def photo
    self.price.product.photo
  end

  def additionable?
    false
  end

  def quantitable?
    false
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