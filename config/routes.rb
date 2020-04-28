Rails.application.routes.draw do
  resources :products
  resources :categories
  devise_for :users
  root 'products#index'

  get 'user/:id', to: 'users#show', as: 'user'
  get 'changestatus/:id', to: 'products#change_status', as: 'change_status'

  resources :products do
    member do
      delete :delete_image
    end
  end
end
