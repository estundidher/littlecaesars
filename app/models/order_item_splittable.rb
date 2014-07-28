class OrderItemSplittable < OrderItem

  before_destroy :destroy_halfs

  belongs_to :first_half,
             class_name: 'OrderItemSizableAdditionable',
             foreign_key: :first_half_id,
             validate: true

  belongs_to :second_half,
             class_name: 'OrderItemSizableAdditionable',
             foreign_key: :second_half_id,
             validate: true

  belongs_to :size

  validates :size,
            presence: true

  validates :size_name,
            presence: true

  validates :first_half,
            presence: true

  validates :second_half,
            presence: true

  validate :product_quantitable?

  def self.create order, cart_item
    OrderItemSplittable.new order: order,
                             size: cart_item.size,
                        size_name: cart_item.size.name,
                         quantity: cart_item.quantity,
                     product_name: cart_item.name,
                            price: cart_item.total,
                       first_half: OrderItemSizableAdditionable.create_half(cart_item.first_half),
                      second_half: OrderItemSizableAdditionable.create_half(cart_item.second_half)
  end

  def product_quantitable?
    if self.first_half.instance_of?(OrderItemQuantitable) or self.second_half.instance_of?(OrderItemQuantitable)
      errors.add :product, 'Cannot be quantitable!'
    end
  end

  def product_price
    [self.first_half.product_price, self.second_half.product_price].max
  end

  def highest_half
    if self.first_half.product_price == self.second_half.product_price
      self.first_half
    elsif self.first_half.product_price > self.second_half.product_price
      self.first_half
    else
      self.second_half
    end
  end

  def lowest_half
    if self.first_half.product_price == self.second_half.product_price
      self.second_half
    elsif self.first_half.product_price < self.second_half.product_price
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
    self.first_half.size
  end

  def quantity
    1
  end

  private

    def destroy_halfs
      self.first_half = nil
      self.second_half = nil
    end
end