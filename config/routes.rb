Rails.application.routes.draw do
  devise_for :users
  
  namespace :api, defaults: { format: :json } do
    post '/user', to: 'users#create'
    post '/user/game_event', to: 'game_events#create'
    get '/user', to: 'users#user_details'
    resources :sessions, only: [:create]
  end
end
