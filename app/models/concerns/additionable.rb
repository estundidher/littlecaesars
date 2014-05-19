module Additionable
  extend ActiveSupport::Concern

  included do

    has_and_belongs_to_many :additions,
                            join_table: :cart_items_products,
                            class_name: 'Product',
                            foreign_key: :cart_item_id,
                            validate:false

  has_and_belongs_to_many :subtractions,
                          join_table: :cart_items_subtractions,
                          class_name: 'Product',
                          foreign_key: :cart_item_id,
                          validate:false
  end

  def total
    if self.additions
      self.product_price + self.additions.inject(0) {|sum, addition| sum + addition.price}
    else
      self.product_price
    end
  end

end