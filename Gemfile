source 'http://rubygems.org'

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
gem 'aws-sdk'

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
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  #gem 'better_errors'
  #gem 'sprockets_better_errors'
  gem 'delorean'
end

group :production do
  #heroku integration
  gem 'rails_12factor'
end

gem 'foreigner'

gem 'memcachier'
gem 'dalli', '~> 2.7.1'

gem 'sprockets', '2.11.0'

ruby '2.1.2'
