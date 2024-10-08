Rails.application.routes.draw do
  get "home/welcome"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#welcome"

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create ]
      post "/login", to: "sessions#create"
      # Currency conversion route
      post "/convert", to: "currency#convert"
      get "/exchange_rates", to: "currency#get_exchange_rates"
    end
  end

  # root "posts#index"
end
