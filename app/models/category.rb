class Category < ActiveRecord::Base
  include Auditable, Touchable

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

  has_and_belongs_to_many :items,
                          class_name: 'Category',
                          association_foreign_key: :item_id,
                          after_add: :force_touch,
                          after_remove: :force_touch

  has_and_belongs_to_many :products

  def to_param
    "#{id}-#{name.parameterize}"
  end
end