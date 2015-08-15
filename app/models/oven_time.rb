class OvenTime < ActiveRecord::Base

  belongs_to :place
  validates :place,
            presence: true
            
  validates :time,
            presence: true,
            numericality: {greater_than: 0, less_than: 50}

end