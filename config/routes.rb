Rails.application.routes.draw do
  root 'welcome#home'

  resources :invites, only: [:create]

  namespace :api, path: '/', format: true, defaults: { format: :json } do
    resources :decrees, only: [] do
      get :sync, on: :collection
    end
  end
end
