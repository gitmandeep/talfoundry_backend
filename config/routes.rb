Rails.application.routes.draw do
  get 'home/index'
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get 'admins/approve_freelancer/:id', to: 'admins#approve_freelancer'
      get 'admins/block_freelancer/:id', to: 'admins#block_freelancer'
      get 'admins/admin_filter', to: 'admins#admin_filter'
      resources :admins, only: [:index]

      resources :users, except: [:create] do
        member do
          get :user_details
        end
        collection do
          post :create_security_questions
        end
      end

      resources :security_questions, only: [:index, :edit, :destroy]

      get 'freelancer_index', to: 'freelancer#freelancer_index'
      get 'freelancer_details/:id', to: 'freelancer#freelancer_details'
      get 'hire_freelancer_details/:id', to: 'freelancer#hire_freelancer_details'
      get 'get_invites', to: 'freelancer#get_invites'
      get 'get_offers', to: 'freelancer#get_offers'
      get 'active_contracts', to: 'freelancer#active_contracts'
      get 'get_submitted_proposals', to: 'freelancer#get_submitted_proposals'
      get 'get_favorited_jobs', to: 'freelancer#favorited_jobs'
      get 'manager_active_contracts', to: "contract#manager_active_contracts"
      get 'get_template_details', to: "jobs#get_template_details"

      resources :project_managers, only: [:index, :show] do
        collection do
          get :favorited_freelancers
        end
      end

      resources :favorites, only: [:create, :index]
      get 'remove_favorited', to: "favorites#remove_favorited"
      resources :profiles
      resources :educations
      resources :employments
      resources :certifications
      resources :job_screening_questions, only: [:destroy]
      resources :job_applications, only: [:create, :show, :destroy]
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
      get '/payments/authenticate_payment_method' => 'payments#authenticate_payment_method'
      post '/payments/set_payment_method' => 'payments#set_payment_method'
      get '/payments/remove_payment_method' => 'payments#remove_payment_method'

      resources :payments, only: [:create]

      resources :invite, only: [:update, :show]
      resources :welcome, only: [:index, :show]

      resources :jobs do
        collection do
          get :jobs_by_user
          get :get_all_jobs
          get :get_all_hired_freelancers
        end
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
        collection do
          get :search_conversation
          get :get_conversation
        end
      end
      resources :messages, only: [:create]
    end
  end

  devise_for :users

  root 'home#index'
end
