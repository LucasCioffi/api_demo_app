Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    post '/user', to: 'users#create'
    resources :sessions, only: [:create]
  end

end
