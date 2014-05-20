class CartItem < ActiveRecord::Base

  belongs_to :cart

  validates :cart,
            presence: { if: :cart_required?, message: 'is forgotten.' }

  def cart_required?
    !self.is_a?(CartItemSizableAdditionable)
  end
end