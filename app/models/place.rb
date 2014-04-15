class Place < ActiveRecord::Base
  include Auditable

  has_many :opening_hours, :dependent => :destroy

  has_attached_file :photo,
                    styles: {medium:"300x300>", thumb:"100x100>"},
                    default_url: "/images/:style/missing.png"

  validates :name,
            presence: true,
            length: {maximum: 30},
            uniqueness: true

  validates :address,
            presence: true,
            length: {maximum: 100},
            uniqueness: true

  validates :phone,
            presence: true,
            length: {maximum: 30},
            uniqueness: true

  validates :description,
            presence: true,
            length: {maximum: 100}

  validates :map,
            length: {maximum: 300},
            uniqueness: true

  validates_attachment :photo,
                       content_type: {content_type:["image/jpg", "image/gif", "image/png"]},
                       size: {in: 0..500.kilobytes}

  # Validate filename
  validates_attachment_file_name :photo,
                                matches: [/png\Z/, /jpe?g\Z/]
end