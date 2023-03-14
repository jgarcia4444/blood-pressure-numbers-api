Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "sessions#welcome"
  post '/users', to: 'users#create'
  post '/users/login', to: 'sessions#login'

  post 'users/:user_id/records', to: 'records#create'

  get 'records/:user_id', to: "records#index"

  post 'users/verification-code', to: 'users#send_user_code'
  post 'users/check-code-verification', to: "users#verify_user_code"
  put 'users/update-password', to: "users#change_password"

  delete 'records/delete/:user_id/:record_id', to: 'records#destroy'
  put 'records/update', to: 'records#update'

  get 'day-streak/:user_id', to: 'day_streaks#show'
  post 'day-streaks', to: "day_streaks#create"
  put 'day-streak', to: "day_streaks#update"

  get 'records/filter/date-range/:from_date/:to_date/:user_id', to: "records#filtered_records"

  get 'forum-messages', to: "forum_messages#index"
  post 'forum-messages/add', to: "forum_messages#create"
end
