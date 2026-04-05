Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  # devise_for :users # Handled manually in API

  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"
      get "auth/profile", to: "auth#profile"

      resources :conversations do
        resources :messages, only: [ :index, :create, :show ]
      end

      resources :friendships, only: [ :index, :create, :destroy ] do
        resource :acceptance, only: :create, module: :friendships
      end

      get "users/search", to: "users#search"
      patch "users/profile", to: "users#update_profile"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
