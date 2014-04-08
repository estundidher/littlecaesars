class Dish < ActiveRecord::Base

  has_many :prices, through: :prices

  has_and_belongs_to_many :ingredients

  has_attached_file :photo,
                    :styles => {:medium => "300x300>", :thumb => "100x100>"},
                    :default_url => "/images/:style/missing.png"

  belongs_to :category

  validates :name,
            :presence => true,
            :length => {:maximum => 50},
            :uniqueness => true

  validates :description,
            :length => {:maximum => 200}

  validates_attachment :photo,
                       :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
                       :size => { :in => 0..500.kilobytes }

  # Validate filename
  validates_attachment_file_name :photo, :matches => [/png\Z/, /jpe?g\Z/]
end