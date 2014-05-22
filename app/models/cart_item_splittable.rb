class CartItemSplittable < CartItem

  after_destroy :destroy_halfs

  belongs_to :first_half,
             class_name: 'CartItemSizableAdditionable',
             foreign_key: :first_half_id,
             validate: true

  belongs_to :second_half,
             class_name: 'CartItemSizableAdditionable',
             foreign_key: :second_half_id,
             validate: true

  accepts_nested_attributes_for :first_half,
                                allow_destroy: true,
                                reject_if: :all_blank

  accepts_nested_attributes_for :second_half,
                                allow_destroy: true
  validates :first_half,
            presence: true

  validates :second_half,
            presence: true

  validate :product_quantitable?

  def destroy_halfs
    self.first_half.destroy
    self.second_half.destroy
  end

  def product_quantitable?
    if self.first_half.instance_of?(CartItemQuantitable) or self.second_half.instance_of?(CartItemQuantitable)
      errors.add :product, 'Cannot be quantitable!'
    end
  end

  def product_price
    [self.first_half.product_price, self.second_half.product_price].max
  end

  def highest_half
    if self.first_half.product_price > self.second_half.product_price
      self.first_half
    else
      self.second_half
    end
  end

  def lowest_half
    if self.first_half.product_price < self.second_half.product_price
      self.first_half
    else
      self.second_half
    end
  end

  def total
    product_price + (self.first_half.total_of_additions + self.second_half.total_of_additions)
  end

  def additionable?
    true
  end

  def quantitable?
    false
  end

  def sizable?
    true
  end

  def name
    "1/2 #{self.first_half.name} 1/2 #{self.second_half.name}"
  end

  def photo
    self.first_half.photo
  end

  def size
    self.first_half.price.size
  end

  def quantity
    1
  end
end