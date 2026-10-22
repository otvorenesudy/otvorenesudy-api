# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module OpenCourtsApi
  class Application < Rails::Application
    config.load_defaults 8.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = 'Europe/Bratislava'

    config.i18n.available_locales = %i[sk en]
    config.i18n.default_locale = :sk
    config.i18n.load_path += Rails.root.glob('config/locales/**/*.yml')

    # db/structure.sql and db/opencourts_structure.sql: the schemas have pgvector columns that schema.rb can't express.
    config.active_record.schema_format = :sql

    config.active_job.queue_adapter = :sidekiq

    # A field with errors shows it by a class (the invite form's .error), not by a wrapping div.
    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }

    # The API's callers have always had U+2028 and U+2029 escaped in its JSON ( ), as Rails did before 8.1.
    config.active_support.escape_js_separators_in_json = true

    # The bootstrap gem is here for its SCSS. Its JavaScript, and popper_js's, are global bundles named like the modules
    # in vendor/javascript (bootstrap.js), and Propshaft serves the first file of a name: with the gems inside the app
    # (vendor/bundle, as in CI), that was the gem's.
    config.assets.excluded_paths += %w[bootstrap popper_js].map do |name|
      Pathname(Gem.loaded_specs.fetch(name).full_gem_path).join('assets/javascripts')
    end

    config.skylight.probes << 'active_job'

    config.generators do |generate|
      generate.test_framework :rspec
      generate.system_tests nil
    end
  end
end
