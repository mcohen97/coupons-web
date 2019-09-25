Rails.application.routes.draw do
  get 'home/index', to: 'home#index', as: 'home'
  post '/home/invite', to: 'home#invite', as: 'invite'
  get '/login/index', to: 'login#index', as: 'login'
  post '/login/create', to: 'login#create', as: 'register'
  root 'login#index'
  post '/promotions/evaluate', to: 'promotions#evaluate', as: 'evaluate_promotion'

  resources :users
  resources :promotions
end
