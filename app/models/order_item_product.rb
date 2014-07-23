class OrderItemProduct < ActiveRecord::Base

  enum kinds: [:addition, :subtraction]

  belongs_to :order_item

  belongs_to :product

  validates :order_item,
            presence: true

  validates :addition_type,
            presence: true

  validates :product,
            presence: true
end