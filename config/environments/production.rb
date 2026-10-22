# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # The production credentials' key, which Capistrano links in (config/deploy.rb).
  config.require_master_key = true

  # nginx serves /assets itself; this covers anything it passes through.
  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.year.to_i}" }

  # nginx terminates TLS.
  config.assume_ssl = true
  config.force_ssl = true

  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger($stdout)
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  config.cache_store = :mem_cache_store

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]
end
