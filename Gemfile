source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'recaptcha', require: 'recaptcha/rails'

# picture upload
gem 'paperclip', github:'thoughtbot/paperclip'

gem 'activemerchant'

gem 'validate_url'

# pagination..
gem 'kaminari'

gem 'devise'

#Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# S3 API
# Added by Diego
#gem 'aws-sdk' It will load the v2 which causes assets compilation issues. Added by Diego
gem 'aws-sdk'
gem 'aws-sdk-v1'

gem 'money-rails'

# Use postgrees as the database for Active Record
gem 'pg'

group :test, :development do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.4.1'
  gem 'pry-rails'
  
  # Added by Diego
  gem 'tzinfo-data'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  #gem 'better_errors'
  #gem 'sprockets_better_errors'
  gem 'delorean'
end

# By default Rails 4 will not serve your assets. To enable this functionality the line below is needed
group :production do
  #heroku integration
  gem 'rails_12factor'
  gem 'rack-cache' #Enable Rack::Cache to put a simple HTTP cache in front of your application
  gem 'heroku-deflater' #Enable gzip compression on heroku, but don't compress images.
end

gem 'foreigner'

gem 'memcachier'
gem 'dalli', '~> 2.7.1'

gem 'sprockets', '2.11.0'

# TimeDifference is the missing Ruby method to calculate difference between two given time. You can do a Ruby time difference in year, month, week, day, hour, minute, and seconds.
gem 'time_difference', '~> 0.4.2'
gem 'data-confirm-modal', github: 'ifad/data-confirm-modal' # Change confirm style to modal 

# Added by Diego
#ruby '2.1.2'
ruby '2.0.0'