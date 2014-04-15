class Category < ActiveRecord::Base
  include Auditable

  validates :name,
            presence: true,
            length: {maximum: 30},
            uniqueness: true
end