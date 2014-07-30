require 'digest/sha1'

class Order < ActiveRecord::Base

  belongs_to :customer
  belongs_to :pick_up

  after_create :create_code

  before_destroy :before_destroy

  has_one :payment

  #0=pending  //being prepared by the customer
  #1=sent     //sent to securepay
  #2=approved //approved by securepay
  #3=declined //declined by securepay
  #3=canceled //declined by securepay
  enum state: [:pending, :sent, :approved, :declined, :cancelled]

  validates :state,
            presence: true

  validates :price,
            presence: true

  validates :customer,
            presence: true

  validates :pick_up,
            presence: true

  validates :ip_address,
            presence: true

  has_many :items, -> {order id: :desc},
           dependent: :destroy,
           class_name:'OrderItem'

  def self.create cart, ip_address
    order = Order.new customer:cart.customer,
                         state:Order.states[:pending],
                         price:cart.total,
                       pick_up:PickUp.new(place:cart.pick_up.place, date:cart.pick_up.date),
                    ip_address:ip_address

    cart.items.each do |cart_item|
      order.create_item cart_item
    end
    return order
  end

  def create_item cart_item
    case cart_item
      when CartItemSplittable
        self.items << OrderItemSplittable.create(self, cart_item)
      when CartItemSizableAdditionable
        self.items << OrderItemSizableAdditionable.create(self, cart_item)
      when CartItemSizable
        self.items << OrderItemSizable.create(self, cart_item)
      when CartItemAdditionable
        self.items << OrderItemAdditionable.create(self, cart_item)
      when CartItemQuantitable
        self.items << OrderItemQuantitable.create(self, cart_item)
    end
  end

  def self.current customer
    find_by customer:customer
  end

  def self.current_pending customer
    find_by customer:customer, state:Order.states[:pending]
  end

  def allow_send?
    self.pending? || self.declined?
  end

  def post
    self.attempts+=1
    self.sent!
  end

  def decline!
    if self.max_of_attempts?
      self.declined!
    end
  end

  def max_of_attempts?
    self.attempts == 3
  end

  def approve!
    self.approved!
    CustomerMailer.new_order(self).deliver
  end

private

  def create_code
    self.code = "#{self.pick_up.place.code}#{self.id.to_s.rjust(8, '0')}"
    save
  end

  def before_destroy
    self.payment.destroy if self.payment.present?
  end
end