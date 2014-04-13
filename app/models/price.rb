class Price < ActiveRecord::Base

  belongs_to :dish
  belongs_to :size

  validates :dish,
            :presence => true

  validates :size,
            :presence => true,
            uniqueness: { scope: :dish, message: "should have one Size per Dish!" }

  validates :value,
            :presence => true,
            :numericality => {:greater_than => 0.00, :less_than => 100.00}
end