# frozen_string_literal: true

require 'sidekiq/web'

# This app's jobs live in Redis database 1; database 0 is otvorenesudy's, which UpdateNotifier pushes into.
redis = { url: 'redis://localhost:6379/1' }

Sidekiq.configure_server { |config| config.redis = redis }
Sidekiq.configure_client { |config| config.redis = redis }

# The dashboard (/sidekiq) asks for the password in the credentials; without one, it stays locked.
Sidekiq::Web.configure do |config|
  config.use Rack::Auth::Basic, 'Sidekiq' do |_, password|
    expected = Rails.application.credentials.dig(:sidekiq, :password)

    expected.present? && ActiveSupport::SecurityUtils.secure_compare(password, expected)
  end
end
