class Product < ActiveRecord::Base
  include Auditable

  scope :items_not_allowed, -> { joins(:type).where(product_types: {allowItems:false}).order(:name) }

  has_many :prices, dependent: :destroy
  has_many :sizes, through: :prices

  has_and_belongs_to_many :items,
                          class_name: 'Product',
                          foreign_key: :product_id,
                          association_foreign_key: :item_id,
                          through: :products_products

  has_attached_file :photo,
                    styles: {medium:"300x300>", thumb:"100x100>"},
                    default_url: "/images/:style/missing.png"

  belongs_to :type,
             class_name: 'ProductType',
             foreign_key: 'product_type_id'

  belongs_to :category

  validates :name,
            presence: true,
            length: {maximum: 50},
            uniqueness: true

  validates :name,
            presence: true

  validates :category,
            presence: true

  validates :description,
            length: {maximum: 200}

  validates :price,
            numericality: true,
            presence: true, if: :priceable?

  def priceable?
    !self.type.sizable?
  end

  validates_attachment :photo,
                       content_type: {content_type:["image/jpg", "image/gif", "image/png"]},
                       size: {in: 0..500.kilobytes}

  # Validate filename
  validates_attachment_file_name :photo,
                                matches: [/png\Z/, /jpe?g\Z/]

  def items_friendly
    self.items.map(&:name).join(', ')
  end
end