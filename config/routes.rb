require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: {
      registrations: "users/registrations"
    }
    get "profiles", to: "profile#index", as: :profiles
    scope "profile/:id", as: "profile" do
      get "/", to: "profile#show", as: ""
      get "/followers", to: "profile#followers", as: "followers"
      get "/following", to: "profile#following", as: "following"
    end
    resources :articles do
      resources :comments, only: [ :create, :edit, :update, :destroy ]
      resources :favorites, only: %i[create destroy]
    end
    scope "notifications" do
      post ":id/read", to: "notifications#read", as: :read_notification
      delete "delete_all", to: "notifications#delete_all", as: :delete_all_notifications
    end
    resources :relationships, only: %i[create destroy]
    get "search", to: "static_page#search_result", as: :search
    root "static_page#home"
  end
end
