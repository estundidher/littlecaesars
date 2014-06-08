class Cart < ActiveRecord::Base

  MODE = {one_flavour:'one-flavour', two_flavours:'two-flavours'}

  enum status: [:open, :closed]

  belongs_to :pick_up

  belongs_to :customer

  has_many :items,
           dependent: :destroy,
           class_name: 'CartItem'

  def new_splittable_item first_half, second_half, size, params

    if params.nil?
      item = CartItemSplittable.new cart:self
      item.build_first_half
      item.first_half = self.new_item(first_half, size, params)

      item.build_second_half
      item.second_half = self.new_item(second_half, size, params)
      return item
    else
      CartItemSplittable.new params
    end
  end

  def new_item product, size, params

    if product.type.sizable? && product.type.additionable?
      if params.nil?
        item = CartItemSizableAdditionable.new cart:self
      else
        item = CartItemSizableAdditionable.new params
      end
      if item.price.nil?
        item.price = product.price_of(size)
      end
      item
    elsif product.type.sizable?
      if params.nil?
        item = CartItemSizable.new cart:self
      else
        item = CartItemSizable.new params
      end
      if item.price.nil?
        item.price = product.price_of(size)
      end
      item
    elsif product.type.additionable?
      if params.nil?
        CartItemAdditionable.new cart:self, product: product
      else
        CartItemAdditionable.new params
      end
    elsif product.type.quantitable?
      if params.nil?
        CartItemQuantitable.new cart:self, product: product
      else
        CartItemQuantitable.new params
      end
    end

  end

  def total
    self.items.inject(0) {|sum, item| sum + item.total}
  end

  def pick_up_configurated?
    unless self.pick_up.nil?
      puts "#{'#'*100}> Pick Up configurated at #{self.pick_up.created_at}"
      return self.pick_up.created_at > 10.minutes.ago
    end
    puts "#{'#'*100}> Pick Up not configurated.."
    false
  end

  def self.current current
    find_or_create_by(customer:current, status:Cart.statuses[:open])
  end
end