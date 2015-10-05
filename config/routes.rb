Rails.application.routes.draw do
  # TODO namespace this into subdomain: 'api' in case of merging with main application
  namespace :api, path: '/' do
    resources :decrees, only: [] do
      get :sync, on: :collection
    end
  end
end
