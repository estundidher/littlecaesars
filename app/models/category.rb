class Category < ActiveRecord::Base
  include Auditable

  scope :with_shoppable_products, -> (size = nil) {

    query = joins(:products => :type)
         .where(products:{enabled:true}, product_types: {shoppable:true})

    if size
      query = query.joins(:products => :sizes)
      query = query.where(sizes: {id:size})
    end

    query.order(:updated_at).uniq
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