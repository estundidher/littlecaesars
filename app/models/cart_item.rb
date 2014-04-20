class CartItem < ActiveRecord::Base

  validates :cart,
            presence: true

  validates :product,
            presence: true

  validates :quantity,
            presence: true
end