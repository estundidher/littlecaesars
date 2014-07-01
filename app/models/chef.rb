class Chef < ActiveRecord::Base
  include Auditable

  NULL_ATTRS = %w( facebook twitter plus pinterest )
  before_validation :nil_if_blank

  has_attached_file :avatar,
                    :s3_protocol => 'https',
                    styles: {large:'250x250>', small:'125x125>'},
                    default_url: '/images/:style/missing.png'

  has_attached_file :background,
                    :s3_protocol => 'https',
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
            uniqueness: true,
            url: {allow_nil: true}

  validates :twitter,
            length: {maximum: 100},
            uniqueness: true,
            url: {allow_nil: true}

  validates :plus,
            length: {maximum: 100},
            uniqueness: true,
            url: {allow_nil: true}

  validates :pinterest,
            length: {maximum: 100},
            uniqueness: true,
            url: {allow_nil: true}

  validates_attachment :avatar,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes},
                       presence: true

  validates_attachment :background,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes},
                       presence: true

protected

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

end