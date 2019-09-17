Rails.application.routes.draw do
  get 'home/index', 'home#index', 'home'
  post '/home/invite', 'home#invite', 'invite'
  get '/login/index', 'login#index', 'login'
  post '/login/create', 'login#create', 'login'
  root 'login#index'
  
  resources :users
  resources :promotions
end
