# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
  end

  get 'home/index', to: 'home#index', as: 'home'
  get 'home/invitation', to: 'home#invitation', as: 'invitation'
  post '/home/invite', to: 'home#invite', as: 'invite'
  get '/login/index', to: 'login#index', as: 'login'
  post '/login/create', to: 'login#create', as: 'register'
  post '/promotions/evaluate', to: 'promotions#evaluate', as: 'evaluate_promotion'
  get '/promotions/report/:id', to: 'promotions#report', as: 'generate_report'

  root 'home#index'

  resources :promotions
  resources :application_keys

  #get '/application_keys', to: 'application_keys#index', as: 'application_keys'
  #get '/application_keys/new', to: 'application_keys#new', as: 'new_application_key'
  #get '/application_keys/:id', to: 'application_keys#show', as: 'application_key'
  #get '/application_keys/:id/edit', to: 'application_keys#edit', as: 'edit_application_key'
  #delete '/application_keys/:id', to: 'application_keys#destroy', as: 'destroy_application_key'
  #post '/application_keys', to: 'application_keys#create', as: 'create_application_key'

end
