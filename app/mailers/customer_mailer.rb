class CustomerMailer < ActionMailer::Base

  default from: 'info@littlecs.com'

  def new_order order
    @order = order
    mail to:@order.customer.email,
         subject:"Thank you for purchasing at Little Cs"
  end

end