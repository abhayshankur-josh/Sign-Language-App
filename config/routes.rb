# == Route Map
#

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/signup", to: "auth#signup"
      delete "auth/signout", to: "auth#signout"
      get "auth/profile", to: "auth#profile"

      get "submissions", to: "submissions#get_submissions"
      post "submissions", to: "submissions#create_submission"
      get "submissions/view", to: "submissions#get_submissions_view"
      get "submissions/view/:id", to: "submissions#get_submissions_view_for"
      post "submissions/status", to: "submissions#action_submission"

      get "signs", to: "signs#get_all"

      get "/*a", to: "application#not_found"
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root path
  root to: "home#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Routes for home :
  get "/signs",                  to: "home#signs"

  # Routes for learner :
  resources :learner, only: [ :index ]

  # Routes for admins :
  get     "/admins/dashboard",       to: "admins#dashboard"
  get     "/admins/users",           to: "admins#users_tab"
  post    "/admins/user",            to: "admins#create_user"
  get     "/admins/videos",          to: "admins#videos_tab"
  post    "/admins/video",           to: "admins#form_videos"
  get     "/admins/video/:sign",     to: "admins#card_details"
  get     "/admins/signs",           to: "admins#signs_tab"
  get     "/admins/submissions",     to: "admins#submissions_tab"
end
