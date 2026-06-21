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

  resources :albums do
    resources :images, only: %i[create destroy] do
      post :mark_downloaded, on: :member
    end
    patch 'generate_password', on: :member
    get :download_all, on: :member
    post :download_selected, on: :member
  end

  resources :expenses do
    member do
      patch :refund
      patch :cancel
    end
  end
  resources :brochures, only: %i[show create destroy] do
    member do
      get :edit_layout # 👈 editor
      patch :update_theme
      patch :toggle_watermark
    end
    resources :invitation_guests, only: [:create, :destroy]
  end

  resources :brochure_blocks, only: [:update] do
    member do
      patch :image, action: :update_image
      patch :reorder
    end
  end

  resources :photographers, only: %i[index create destroy]

  # Client access routes
  get 'albums/:id/access', to: 'client_access#show', as: :album_access
  post 'albums/:id/authenticate', to: 'client_access#authenticate', as: :album_authenticate
  get 'albums/:id/gallery', to: 'client_access#gallery', as: :album_gallery
  get 'sessions', to: 'sessions#index'

  get "/i/:token", to: "invitations#show", as:"invitation"
  get "/i/:token/open", to:"invitations#open", as:"open_invitation"
  patch "/i/:token", to:"invitations#update"

  post "/client/checkin/:token", to:"client_access#checkin", as:"client_checkin"

  get 'albums/:id/admin-access', to: 'client_access#admin_access', as: :album_admin_access
end
