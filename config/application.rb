require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module ApiAccessEvanta
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W(#{config.root}/lib)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :en
    # config.i18n.fallbacks = true
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Headers' => 'X-AUTH-TOKEN, X_API_TENANT, X_API_EMAIL, X-API-VERSION, X-Requested-With, Content-Type, Accept, Origin, Authorization, X-CSRF-Token'
    }
    config.secret_key_base = 'QjBtJIxNjddh82g71lcrP6Ju41EE21MH'
    
    config.i18n.enforce_available_locales = true
  end
end

# Clear memcached store
Rails.application.config.after_initialize do
  Rails.cache.clear
  $tenant = Tenant.new
end