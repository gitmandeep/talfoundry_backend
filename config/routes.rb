Rails.application.routes.draw do
  
  get 'home/index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      
      resources :users, except: [:create]
      
      resources :profiles 
       
      post '/login', to: 'authentication#login'   
      post '/signup', to: 'users#create'
      get '/user_full_name', to: 'users#user_full_name', as: 'user_full_name'
      get '/confirm_email', to: 'users#confirm_email', as: 'confirm_email' 
      post '/interview_call_schedule', to: 'users#interview_call_schedule', as: 'interview_call_schedule' 
      
      post '/forgot_password', to: 'password#forgot_password'
      post '/reset_password', to: 'password#reset_password'
      
      resources :jobs do
        get :jobs_by_user, on: :collection
      end

    end
  end

  devise_for :users

  root 'home#index'
end
