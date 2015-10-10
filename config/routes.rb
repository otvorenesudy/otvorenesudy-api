Rails.application.routes.draw do
  root to: redirect('http://otvorenesudy.sk/api')

  # TODO namespace this into subdomain: 'api' in case of merging with main application
  namespace :api, path: '/', format: true, defaults: { format: :json } do
    resources :decrees, only: [] do
      get :sync, on: :collection
    end
  end
end
