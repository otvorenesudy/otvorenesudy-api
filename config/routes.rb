Rails.application.routes.draw do
  scope module: :api do
    constraints subdomain: 'api' do
      resources :decrees, only: [] do
        get :sync, on: :collection
      end
    end
  end
end
