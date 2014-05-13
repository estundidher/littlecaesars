class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :authentication_keys => [:email]

  validates :email,
            uniqueness: {case_sensitive: false}

  validates :name,
            presence: true,
            format: {with:/\A[a-zA-Z]+\z/}

  validates :surname,
            presence: true,
            format: {with:/\A[a-zA-Z]+\z/}

  validates :mobile,
            #numericality: {only_integer: true},
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