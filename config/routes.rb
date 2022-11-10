Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/users', to: 'users#create'
  post '/users/login', to: 'sessions#login'

  post 'users/:user_id/records', to: 'records#create'
end
