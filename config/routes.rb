Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[create]
      resources :ratings, only: %i[create]
    end
  end
end
