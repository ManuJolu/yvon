require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "attachinary/orm/active_record"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)



module Yvon
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
    end
    # ajax
    config.action_view.embed_authenticity_token_in_remote_forms = true
    # Auto-load the bot and its subdirectories
    config.paths.add File.join('app', 'bot'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'bot', '*')]
    # Time Zone
    config.time_zone = "Europe/Paris"
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr, :en]
    config.i18n.fallbacks = { en: :fr, ru: :en }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end



