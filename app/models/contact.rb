class Contact
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :email, :message, :name

  validates :name,
            presence: true

  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            presence: true

  validates :message,
            presence: true

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def persisted?
    false
  end

end