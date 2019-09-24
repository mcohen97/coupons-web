Rails.application.routes.draw do
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      confirmations: 'users/confirmations',
      sessions: 'users/sessions'
  }

  get 'home/index', 'home#index', 'home'
  post '/home/invite', 'home#invite', 'invite'
  get '/login/index', 'login#index', 'login'
  post '/login/create', 'login#create', 'login'
  root 'home#index'
  resources :promotions
end
