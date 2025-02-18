Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[create] do
        collection do
          get "recurrent_ips", to: "posts#recurrent_ips"
        end
      end
      resources :ratings, only: %i[create] do
        collection do
          get "ranking", to: "ratings#ranking"
        end
      end
    end
  end
end
