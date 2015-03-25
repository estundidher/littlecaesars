class Price < ActiveRecord::Base

  belongs_to :product, touch: true
  belongs_to :size

  validates :product,
            presence: true

  validates :size,
            presence: true,
            uniqueness: {scope: :product, message: "should have one Price per Size per Product!"}

  validates :value,
            presence: true,
            numericality: {greater_than: 0.00, less_than: 100.00}
end