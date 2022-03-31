Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'searches#find_merchant'
      get '/items/find_all', to: 'searches#find_items_by_name'
      resources :merchants, only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: [:index]
      end
      resources :items do
        resources :merchant, controller: 'merchant_items', only: [:index]
      end
    end
  end
end
