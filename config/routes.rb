Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations, :passwords, :confirmations ], 
    controllers: { omniauth_callbacks: "users/omniauth_callbacks",
                   invitations: "users/invitations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    get "users/current_user" => "users#client_user"
    delete "users/sign_out" => "users#log_out"
    get "teams/users" => "teams#team_users"
    get "teams/users/:user_id" => "teams#team_user"
    post "posts/:post_id/comments" => "comments#create"
    post "posts/:post_id/reactions" => "reactions#create"
    delete "group_users", to: "group_users#destroy"
    post "groups/:group_id/join", to: "group_users#join"
    post "groups/:group_id/leave", to: "group_users#leave"
    post "notifications/mark_all_as_read", to: "notifications#mark_all_as_read"
    get "notifications/unread_count", to: "notifications#unread_count"
    resources :groups
    resources :group_users, except: [:destroy]
    resources :posts
    resources :comments
    resources :reactions
    resources :notifications
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "dashboard" => "pages#dashboard", as: :dashboard

  # Defines the root path route ("/")
  root to: "pages#index"
end
