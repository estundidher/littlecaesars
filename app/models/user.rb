class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         authentication_keys: [:username]

  validates :username,
            uniqueness: {case_sensitive: false},
            presence: true, if: :admin

  validates :email,
            uniqueness: {case_sensitive: false},
            presence: true, unless: :admin

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end
end