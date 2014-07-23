module OrderItemProductAdditionable
  extend ActiveSupport::Concern

  included do

    store_accessor :additions
    store_accessor :subtractions

    def total_of_additions
      self.additions.inject(0) {|sum, addition| sum + addition.value}
    end

    def total
      if self.additions.present?
        self.product_price + self.total_of_additions
      else
        self.product_price
      end
    end
    def additions=(additions)
      self[:additions] = {}
      additions.each do |addition|
        self[:additions][addition.name.to_sym] = addition.price.to_s
      end
    end
    def subtractions=(subtractions)
      self[:subtractions] = {}
      subtractions.each do |subtraction|
        self[:subtractions][subtraction.name.to_sym] = subtraction.price.to_s
      end
    end
  end
end