class Customer < ActiveRecord::Base

  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :authentication_keys => [:email]

  has_one :cart

  has_many :orders

  validates :email,
            uniqueness: {case_sensitive: false}

  validates :name,
            presence: true

  validates :surname,
            presence: true

  validates :mobile,
            presence: true

  def self.current
    Thread.current[:customer]
  end
  def self.current=(customer)
    Thread.current[:customer] = customer
  end

  def full_name
    "#{self.name} #{self.surname}"
  end
end