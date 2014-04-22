class ProductType < ActiveRecord::Base
  include Auditable

  validates :name,
            presence: true,
            length: {maximum: 50},
            uniqueness: true

  def priceable?
    !self.sizable?
  end

  def quantitable?
    !self.additionable?
  end

  def splittable
    !self.quantitable?
  end
end