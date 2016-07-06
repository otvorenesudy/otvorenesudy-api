Rails.application.routes.draw do
  root 'welcome#index'

  resources :invites, only: [:create]

  namespace :api, path: '/', format: true, defaults: { format: :json } do
    resources :decrees, only: [:show] do
      get :sync, on: :collection
    end
  end

  namespace :public, path: '/public', format: true, default: { format: :json } do
    resources :prosecutor_refinements, only: [:create]
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
