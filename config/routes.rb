Rails.application.routes.draw do
  get "pages/index"

  get "/messages",    to: "postulations#message", as: "message_postulations"
  get "/contests",    to: "offers#contest",       as: "contest_offers"
  get "/pages/exito", to: "pages#exito",          as: "pages_exito"

  resources :postulations, except: [ :create ]

  resources :offers do
    resources :postulations, only: [ :create ]
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # Defines the root path route ("/")
  root "pages#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
