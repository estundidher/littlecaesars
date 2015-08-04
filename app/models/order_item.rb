class OrderItem < ActiveRecord::Base

  store_accessor :properties, :size_name, :product_name

  belongs_to :order

  validates :order,
            presence: {if: :order_required?, message:'is forgotten.'}

  def order_required?
    !self.is_a?(OrderItemSizableAdditionable)
  end
  
  # Function used on admin live page
  def size_name_small
    if self.size_name == "Big Cs 13\""
      "BC13\""
    elsif self.size_name == "Little Cs 10\""
      "LC10\""
    elsif self.size_name == "Gluten Free 12\""
      "GF12\""
    else
      self.size_name
    end  
  end
  
end