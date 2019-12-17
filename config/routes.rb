Rails.application.routes.draw do
  
  get 'home/index'

  mount ActionCable.server => '/cable'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      
 
      get 'admin/approve_freelancer/:id', to: 'admin#approve_freelancer'
      get 'admin/block_freelancer/:id', to: 'admin#block_freelancer'
      
      resources :users, except: [:create] do
        member do
          get :user_details
        end
      end

      get 'freelancer_index', to: 'freelancer#freelancer_index'
      get 'freelancer_details/:id', to: 'freelancer#freelancer_details'
      get 'hire_freelancer_details/:id', to: 'freelancer#hire_freelancer_details'
      get 'get_invites', to: 'freelancer#get_invites'
      get 'get_offers', to: 'freelancer#get_offers'
      get 'active_contracts', to: 'freelancer#active_contracts'
      get 'get_submitted_proposals', to: 'freelancer#get_submitted_proposals'
      get 'get_favorited_jobs', to: 'users#favorited_jobs'
      get 'get_favorited_freelancers', to: "users#favorited_freelancers"
      get 'manager_active_contracts', to: "contract#manager_active_contracts"
      get 'get_template_details', to: "jobs#get_template_details"


      resources :favorites, only: [:create, :index]
      get 'remove_favorited', to: "favorites#remove_favorited"
      resources :profiles
      resources :educations 
      resources :employments
      resources :certifications
      resources :job_screening_questions, only: [:destroy]
      resources :job_applications, only: [:create, :show]
      get 'view_job_proposal', to: 'job_applications#view_job_proposal'

      post '/login', to: 'authentication#login'   
      post '/admin_login', to: 'authentication#admin_login'
      get '/current_user_details', to: 'authentication#current_user_details'
      post '/signup', to: 'users#create'
      get '/user_full_name', to: 'users#user_full_name', as: 'user_full_name'
      get '/confirm_email', to: 'users#confirm_email', as: 'confirm_email'
      get '/resend_confirmation_email', to: 'users#resend_confirmation_email', as: 'resend_confirmation_email'
      post '/interview_call_schedule', to: 'users#interview_call_schedule', as: 'interview_call_schedule'
      
      post '/forgot_password', to: 'password#forgot_password'
      post '/reset_password', to: 'password#reset_password'
      patch 'update_password/:id', to: 'password#update_password'
      post '/send_invitation', to: 'invite#create'

      resources :invite, only: [:update, :show]
      resources :welcome, only: [:index, :show]

      resources :jobs do
        get :jobs_by_user, on: :collection

        member do
          get :job_related_freelancer
          get :invited_freelancer
          get :get_job_proposals
          get :hired_freelancer
          get :get_job_active_contract          
        end
      end

      resources :notifications, only: [:index, :create, :update, :destroy]
      resources :contract, only: [:index, :show, :create, :update]

      resources :conversations, only: [:index, :create, :update] do
        get :search_conversation, on: :collection
      end
      
      resources :messages, only: [:create]


      #get '/search_conversation', to: 'conversations#search_conversation', as: 'search_conversation'




    end
  end

  devise_for :users

  root 'home#index'
end
