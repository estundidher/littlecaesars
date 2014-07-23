class Payment < ActiveRecord::Base

  belongs_to :order

  validates :order, presence: true
  validates :status, presence: true
  validates :code, presence: true
  validates :description, presence: true
  validates :timestamp, presence: true
  validates :fingerprint, presence: true
  validates :ip_address, presence: true
  validates :full_request, presence: true
end