require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Caesars
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Perth'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_record.default_timezone = :local

    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower')
    #config.assets.paths << Rails.root.join('vendor', 'assets', 'bower', 'bootstrap-sass', 'vendor', 'assets', 'fonts')

    # Explicitly register the extensions we are interested in compiling
    #config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
        '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
        '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
      ]
    end)

    #devise configuration for Heroku
    config.assets.initialize_on_precompile = false
    config.serve_static_assets = true
  end
end