require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |_, password|
  password == ENV['OPENCOURTS_API_SIDEKIQ_PASSWORD']
end
