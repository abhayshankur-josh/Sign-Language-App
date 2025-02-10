# == Route Map
#

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root path
  root to: "home#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # Define resorces
  # resources :users
  # resources :admins , only: [:, :dashboard, :userlist]
  get "/admins/dashboard", to: "admins#dashboard"
  get "/admins/users", to: "admins#users_tab"
  get "/admins/videos", to: "admins#videos_tab"
  get "/admins/new-user", to: "admins#add_user_tab"
end
