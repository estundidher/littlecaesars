class PickUp < ActiveRecord::Base

  has_one :cart, dependent: :nullify

  belongs_to :place

  validates :cart,
            presence: true

  validates :place,
            presence: true

  validates :date,
            presence: true
end