# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  # Toggle with `bin/rails dev:cache`.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = { 'cache-control' => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true
  config.action_dispatch.verbose_redirect_logs = true

  # ACTIVE_JOB_INLINE=1 runs the import jobs in the process that enqueues them, without Sidekiq.
  config.active_job.queue_adapter = ENV['ACTIVE_JOB_INLINE'] ? :inline : :sidekiq

  config.assets.quiet = true

  config.i18n.raise_on_missing_translations = true
  config.action_view.annotate_rendered_view_with_filenames = true
  config.action_controller.raise_on_missing_callback_actions = true
end
