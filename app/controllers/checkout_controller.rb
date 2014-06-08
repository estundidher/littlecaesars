require 'rubygems'
require 'active_merchant'

class CheckoutController < ApplicationController

  def index

    #https://github.com/Shopify/active_merchant
    #https://github.com/Shopify/active_merchant/issues/278
    #http://www.securepay.com.au/uploads/Integration%20Guides/Direct_Post_Integration_Guide.pdf
    #http://www.securepay.com.au/uploads/Integration%20Guides/SecureFrame_Integration_Guide.pdf

    # Use the TrustCommerce test servers
    ActiveMerchant::Billing::Base.mode = :test

    gateway = ActiveMerchant::Billing::SecurePayGateway.new(
                login: 'TestMerchant',
                password: 'password')

    # ActiveMerchant accepts all amounts as Integer values in cents
    amount = 1000  # $10.00

    # The card verification value is also known as CVV2, CVC2, or CID
    credit_card = ActiveMerchant::Billing::CreditCard.new(
                    first_name: 'Bob',
                    last_name: 'Bobsen',
                    number: '4242424242424242',
                    month: '8',
                    year: Time.now.year+1,
                    verification_value: '000')

    # Validating the card automatically detects the card type
    if credit_card.validate.empty?

      # Capture $10 from the credit card
      response = gateway.purchase(amount, credit_card)

      puts response

      if response.success?
        render "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
      else
        raise StandardError, response.message
      end
    end

  end
end