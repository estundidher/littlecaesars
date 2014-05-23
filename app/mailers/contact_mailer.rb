class ContactMailer < ActionMailer::Base
  default from: 'info@theoandco.net'

  def request_info name, from, message
    @name = name
    @from = from
    @message = message
    mail to:'rogerio.alcantara@gmail.com', subject:'New contact request'
  end
end