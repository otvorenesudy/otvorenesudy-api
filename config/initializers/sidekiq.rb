require 'sidekiq/web'

Sidekiq.configure_server { |config| config.redis = { url: 'redis://localhost:6379/1' } }
Sidekiq.configure_client { |config| config.redis = { url: 'redis://localhost:6379/1' } }
Sidekiq::Web.use(Rack::Auth::Basic) { |_, password| password == Rails.application.credentials.dig(:sidekiq, :password) }
