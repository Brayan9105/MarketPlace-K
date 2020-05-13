Rails.application.routes.draw do
  root 'pages#welcome'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :categories, only: [:index, :show]

  devise_for :users, controllers: { registrations: 'users/registrations' }
  get 'user/:id', to: 'users#show', as: 'user'
  get 'users', to: 'users#index'

  resources :products
  resources :products do
    member do
      delete :delete_image
    end
  end

  get 'changestatus/:id', to: 'products#change_status', as: 'change_status'
end
