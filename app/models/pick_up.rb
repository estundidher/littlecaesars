class PickUp < ActiveRecord::Base

  has_one :cart, dependent: :nullify
  has_one :order, dependent: :nullify

  belongs_to :place

  validates :cart,
            presence:{unless: :has_order?}

  validates :order,
            presence:{unless: :has_cart?}

  validates :place,
            presence: true

  validates :date,
            presence: true

  def has_order?
    self.order.present?
  end

  def has_cart?
    self.cart.present?
  end
end