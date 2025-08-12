require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 7.1
    config.time_zone = 'Tokyo'
    config.autoload_lib(ignore: %w(assets tasks))
    config.eager_load_paths << Rails.root.join("app/services")
    config.middleware.delete Rack::Runtime
    config.session_store :cookie_store, key: 'b_ses'
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:ja, :en]
  end
end
