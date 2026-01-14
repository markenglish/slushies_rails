require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      resources :stores, only: [:index, :show] do
        resources :stock_snapshots, only: [:index]
      end

      get "stocks/latest", to: "stocks#latest"
    end
  end
end
