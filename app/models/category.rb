class Category < ActiveRecord::Base
  include Auditable

  scope :with_shoppable_products, -> {

    joins(:products => :type)
         .where(products:{enabled:true}, product_types: {shoppable:true})
         .order(:name).uniq
  }

  has_many :products

  validates :name,
            presence: true,
            length: {maximum: 30},
            uniqueness: true

  def to_param
    "#{id}-#{name.parameterize}"
  end
end