class OrderItem < ActiveRecord::Base

  store_accessor :properties, :size_name, :product_name

  belongs_to :order

  validates :order,
            presence: {if: :order_required?, message:'is forgotten.'}

  def order_required?
    !self.is_a?(OrderItemSizableAdditionable)
  end
end