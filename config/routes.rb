Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'products#index'

  resources :categories

  devise_for :users
  get 'user/:id', to: 'users#show', as: 'user'

  resources :products
  resources :products do
    member do
      delete :delete_image
    end
  end

  get 'changestatus/:id', to: 'products#change_status', as: 'change_status'
end
