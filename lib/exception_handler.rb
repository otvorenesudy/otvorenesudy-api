# frozen_string_literal: true

# Runs a scheduled job (config/schedule.rb) and reports its error to Sentry instead of failing the cron run.
module ExceptionHandler
  def self.run
    yield
  rescue StandardError => e
    Sentry.capture_exception(e)
  end
end
