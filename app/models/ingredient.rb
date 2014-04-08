class Ingredient < ActiveRecord::Base

  has_and_belongs_to_many :dishes

  has_attached_file :avatar,
                    :styles => {:medium => "300x300>", :thumb => "100x100>"},
                    :default_url => "/images/:style/missing.png"

  validates :name,
            :presence => true,
            :length => {:maximum => 50},
            :uniqueness => true

  validates :price,
            :presence => true,
            :numericality => true

  validates_attachment :avatar,
                       :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
                       :size => { :in => 0..500.kilobytes }

  # Validate filename
  validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/]
end