Rails.application.routes.draw do
  root 'application#home'

  match '/request_invite' => 'application#request_invite', via: :post

  namespace :api, path: '/', format: true, defaults: { format: :json } do
    resources :decrees, only: [] do
      get :sync, on: :collection
    end
  end
end
