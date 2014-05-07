class Product < ActiveRecord::Base
  include Auditable

  scope :not_additionable_nor_shoppable, -> (except = nil) {

    query = where(enabled:true)

    if except
      query = query.where.not(id:except)
    end

    query.joins(:type)
         .where(product_types: {additionable:false, shoppable:false})
         .order(:name)
  }

  scope :shoppable, -> (limit = nil) {

    where(enabled:true).joins(:type)
                       .where(product_types: {shoppable:true})
                       .order(:name).limit(limit)
  }

  scope :shoppable_additionable, -> (limit = nil) {

    where(enabled:true).joins(:type)
                       .where(product_types: {shoppable:true, additionable:true})
                       .order(:name).limit(limit)
  }

  scope :shoppable_additionable_splittable, -> (limit = nil) {

    where(enabled:true).joins(:type, :sizes)
                       .where(product_types: {shoppable:true, additionable:true})
                       .where(sizes: {splittable:true})
                       .order(:name).limit(limit)
  }

  has_many :prices, dependent: :destroy
  has_many :sizes, through: :prices

  has_and_belongs_to_many :items,
                          class_name: 'Product',
                          association_foreign_key: :item_id,
                          after_add: :force_touch,
                          after_remove: :force_touch

  has_attached_file :photo,
                    styles: {large:'400x450>', medium:'300x300>', mini:'120x60>', thumb:'100x100>'}

  has_attached_file :photo_left,
                    styles: {large:'175x250>'}

  has_attached_file :photo_right,
                    styles: {large:'175x250>'}

  has_attached_file :photo_showcase,
                    styles: {large:'350x250>', thumb: '120x90>'}

  belongs_to :type,
             class_name: 'ProductType',
             foreign_key: 'product_type_id'

  belongs_to :category

  validates :type,
            presence: true

  validates :category,
            presence: true

  validates :name,
            presence: true,
            length: {maximum: 50},
            uniqueness: {case_sensitive: false}

  validates :description,
            length: {maximum: 200}

  validates :price,
            numericality: true,
            presence: true, if: :priceable?

  validates_attachment :photo,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes}

  validates_attachment :photo_left,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes},
                       presence: true, if: :splittable?

  validates_attachment :photo_right,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes},
                       presence: true, if: :splittable?

  validates_attachment :photo_showcase,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes},
                       presence: true, if: :shoppable?

  def force_touch record
    self.touch
  end

  def shoppable?
    self.try(:type).try(:shoppable?)
  end

  def priceable?
    !self.try(:type).try(:sizable?)
  end

  def sizable?
    self.try(:type).try(:sizable?)
  end

  def items_friendly limit = nil
    if limit
      self.items.map(&:name).join(', ').truncate(limit)
    else
      self.items.map(&:name).join(', ')
    end
  end

  def describe limit = nil
    if self.type.additionable
      self.items_friendly limit
    else
      if limit
        self.description.truncate limit
      else
        self.description
      end
    end
  end

  def splittable?
    self.sizes.map{|size| size.splittable} if self.sizable? and self.sizes.any?
  end

  def photo_of side
    if side == 'left'
      self.photo_left
    elsif side == 'right'
      self.photo_right
    end
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end