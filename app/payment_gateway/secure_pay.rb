class SecurePay

  APPROVED = '1'
  DECLINED_BY_BANK = '2'
  DECLINED = '3'

  def initialize(order)
    @order = order
    @timestamp = Time.now.utc.strftime "%Y%m%d%H%M%S"
  end

  def timestamp
    @timestamp
  end

  def reference
    @order.code
  end

  def price
    @order.price
  end

  def password
    'abc123'
  end

  def merchan_id
    'ABC0001'
  end

  def transaction_type
    '0'
  end

  def fingerprint
    Digest::SHA1.hexdigest "#{self.merchan_id}|#{self.password}|#{self.transaction_type}|#{self.reference}|#{self.price}|#{self.timestamp}"
  end
end