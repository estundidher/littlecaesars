class ContactMailer < ActionMailer::Base

  default from:'info@littlecs.com'

  def request_info name, from, message
    @name = name
    @from = from
    @message = message
    mail to:'info@littlecs.com', subject:'New contact request'
  end

end