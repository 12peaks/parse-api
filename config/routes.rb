Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations, :passwords, :confirmations ], controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    get "users/current_user" => "users#client_user"
    delete "users/sign_out" => "users#log_out"
    resources :groups
    resources :group_users
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "dashboard" => "pages#dashboard", as: :dashboard

  # Defines the root path route ("/")
  root to: "pages#index"
end
