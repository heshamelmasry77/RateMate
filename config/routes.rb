Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create ]
      post "/login", to: "sessions#create"
      # Add other routes here
    end
  end

  # root "posts#index"
end
