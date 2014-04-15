class ProductItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :item
end