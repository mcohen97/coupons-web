Rails.application.routes.draw do
  get 'home/index', 'home#index', 'home'
  post '/home/invite', 'home#invite', 'invite'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  get '/login/index', 'login#index', 'login'
  post '/login/create', 'login#create', 'login'
  root 'login#index'
end
