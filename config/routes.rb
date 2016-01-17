Rails.application.routes.draw do
  root 'welcome#index'

  resources :invites, only: [:create]

  namespace :api, path: '/', format: true, defaults: { format: :json } do
    resources :decrees, only: [:show] do
      get :sync, on: :collection
    end
  end

  mount Sidekiq::Web => '/sidekiq'
end
