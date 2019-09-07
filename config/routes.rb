Rails.application.routes.draw do
  
  get 'home/index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      
      resources :users, except: [:create]
      resources :profiles
       
      post '/signup', to: 'users#create'
      post '/login', to: 'authentication#login'
      get '/user_full_name', to: 'users#user_full_name', as: 'user_full_name'
      get '/confirm_email/:id/:confirmation_token', to: 'users#confirm_email', as: 'confirm_email' 
      
    end
  end

  devise_for :users

  root 'home#index'
end
