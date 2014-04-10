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

  def self.available_for price
    if price.id
      order(:name)
    else
      where.not(id:price.dish.sizes).order(:name)
    end
  end

end