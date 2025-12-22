require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root 'apps#index'

  mount Sidekiq::Web => '/sidekiq'

  get '/pages/contact-us', to: 'pages#pages_contact_us'

  get '/users/profile', to: 'users#users_profile', as: 'users_profile'
  get '/users/user-account-settings', to: 'users#users_account_settings'
  patch '/users/update_profile', to: 'users#update_profile', as: 'update_profile'

  # Photographer's routes for managing albums
  resources :receipts
  resources :tarifs
  resources :clients, only: %i[index new create]
  # resources :albums, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :albums do
    resources :images, only: [:create] do
      post :mark_downloaded, on: :member
    end
    patch 'generate_password', on: :member
    get :download_all, on: :member
    post :download_selected, on: :member
  end
  # Client access routes
  get 'albums/:id/access', to: 'client_access#show', as: :album_access
  post 'albums/:id/authenticate', to: 'client_access#authenticate', as: :album_authenticate
  get 'albums/:id/gallery', to: 'client_access#gallery', as: :album_gallery
end
