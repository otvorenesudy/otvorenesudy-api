# frozen_string_literal: true

# Production's secrets come from the encrypted production credentials; the database logins and other settings from the
# environment. Production doesn't boot without these, and says which are missing:
#
#   secret_key_base    signs sessions and cookies
#   sentry.dsn         where errors go
#   sidekiq.password   the Sidekiq dashboard's password
#   skylight.token     performance monitoring
PRODUCTION_SECRETS = [
  [:secret_key_base],
  %i[sentry dsn],
  %i[sidekiq password],
  %i[skylight token]
].freeze

# SECRET_KEY_BASE_DUMMY is Rails' signal that no real secrets are there (building assets): nothing to check then.
if Rails.env.production? && !ENV['SECRET_KEY_BASE_DUMMY']
  missing = PRODUCTION_SECRETS.reject { |path| Rails.application.credentials.dig(*path).present? }

  if missing.any?
    raise "Missing production credentials: #{missing.map { |path| path.join('.') }.join(', ')}. " \
          'Add them with bin/rails credentials:edit --environment production.'
  end
end
