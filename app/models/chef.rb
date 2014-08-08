class Chef < ActiveRecord::Base
  include Auditable

  has_attached_file :avatar,
                    styles: {large:'250x250>', small:'125x125>'},
                    default_url: '/images/:style/missing.png'

  has_attached_file :background,
                    styles: {large:'400x250>', small:'200x125>'},
                    default_url: '/images/:style/missing.png'

  validates :name,
            presence: true,
            length: {maximum: 30},
            uniqueness: true

  validates :position,
            presence: true,
            length: {maximum: 100}

  validates :facebook,
            length: {maximum: 100},
            presence: false

  validates :twitter,
            length: {maximum: 100},
            presence: false

  validates :plus,
            length: {maximum: 100},
            presence: false

  validates :pinterest,
            length: {maximum: 100},
            presence: false

  validates_attachment :avatar,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes},
                       presence: true

  validates_attachment :background,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes},
                       presence: true
end