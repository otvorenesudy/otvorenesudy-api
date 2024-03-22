require File.expand_path('../boot', __FILE__)

require 'rails'

# Pick the frameworks you want:
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'active_job/railtie'
require 'active_model/railtie'
require 'active_record/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OpenCourtsApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Autoload paths
    config.autoload_lib(ignore: %w[assets tasks])

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Europe/Bratislava'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :sk

    # Load all locales
    config.i18n.load_path += Dir[Rails.root.join 'config', 'locales', '**', '*.{rb,yml}']

    # Don't generate system test files
    config.generators.system_tests = nil

    # ActiveJob
    config.active_job.queue_adapter = :sidekiq
  end
end

require 'info_sud'
require 'obcan_justice_sk'
require 'pdf_extractor'
require 'exception_handler'
require 'justice_gov_sk_pages'
