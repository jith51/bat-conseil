require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BatConseil
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.to_prepare do
      Devise::SessionsController.layout "devise" 
    end
    # on renseigne le path du css de foundations site cat _setting fait un import depuis ce repertoire
    config.assets.paths << Rails.root.join("vendor", "assets", "bower_components", "foundation-sites", "scss")
    config.assets.paths << Rails.root.join("vendor", "assets", "bower_components", "foundation-icon-fonts")
    config.assets.paths << Rails.root.join("vendor", "assets", "bower_components", "datatables", "media", "images")

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join('lib')
  end
end
