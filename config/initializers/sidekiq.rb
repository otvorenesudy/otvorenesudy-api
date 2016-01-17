require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |_, password|
  password == ENV['OPENCOURTS_API_SIDEKIQ_PASSWORD']
end
