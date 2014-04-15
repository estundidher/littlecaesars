class ProductType < ActiveRecord::Base
  include Auditable

  validates :name,
            presence: true,
            length: {maximum: 50},
            uniqueness: true
end