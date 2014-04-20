class Cart < ActiveRecord::Base
  enum state: [:open, :closed]
  belongs_to :customer
end