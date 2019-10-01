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
  post '/home/invite', to: 'home#invite', as: 'invite'
  get '/login/index', to: 'login#index', as: 'login'
  post '/login/create', to: 'login#create', as: 'register'
  post '/promotions/evaluate', to: 'promotions#evaluate', as: 'evaluate_promotion'
  get '/promotions/report/:id', to: 'promotions#report', as: 'generate_report'

  root 'home#index'

  resources :promotions
  resources :application_keys
end
