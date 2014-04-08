class Size < ActiveRecord::Base

  has_many :prices, through: :prices

  validates :name,
            :presence => true,
            :length => {:maximum => 30},
            :uniqueness => true

  validates :description,
            :presence => true,
            :length => {:maximum => 100},
            :uniqueness => true
end