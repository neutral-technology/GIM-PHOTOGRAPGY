Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root 'apps#index'
  get 'dashboard/analytics', to: 'dashboard#analytics'

  get '/apps/notes', to: 'apps#notes'
  get '/apps/contacts', to: 'apps#contacts'
  get '/apps/calendar', to: 'apps#calendar'

  get '/pages/faq', to: 'pages#pages_faq'
  get '/pages/contact-us', to: 'pages#pages_contact_us'

  get '/users/profile', to: 'users#users_profile', as: 'users_profile'
  get '/users/user-account-settings', to: 'users#users_account_settings'
  patch '/users/update_profile', to: 'users#update_profile', as: 'update_profile'
end
