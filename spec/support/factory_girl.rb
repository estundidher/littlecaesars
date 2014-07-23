# RSpec
# spec/support/factory_girl.rb
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

Paperclip.options[:command_path] = '/usr/local/bin/'