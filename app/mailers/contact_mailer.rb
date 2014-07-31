class ContactMailer < ActionMailer::Base

  default from: 'info@littlecs.com'

  def request_info name, from, message
    @name = name
    @from = from
    @message = message
    mail to:'info@theoandco.net', subject:'New contact request'
  end
end