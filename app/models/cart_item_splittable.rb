class CartItemSplittable < CartItem

  belongs_to :first_half,
             class_name: 'CartItem',
             foreign_key: :first_half_id

  belongs_to :second_half,
             class_name: 'CartItem',
             foreign_key: :second_half_id

  validates :first_half,
            presence: true

  validates :second_half,
            presence: true

  validate :product_quantitable?

  def product_quantitable?
    if self.first_half.instance_of?(CartItemQuantitable) or self.second_half.instance_of?(CartItemQuantitable)
      errors.add :product, 'Cannot be quantitable!'
    end
  end

end