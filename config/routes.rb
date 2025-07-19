Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: {
      registrations: "users/registrations"
    }
    scope "profile/:id", as: "profile" do
      get "/", to: "profile#show", as: ""
      get "/followers", to: "profile#followers", as: "followers"
      get "/following", to: "profile#following", as: "following"
    end
    resources :articles do
      resources :comments, only: [ :create, :edit, :update, :destroy ]
    end
    resources :relationships, only: %i[create destroy]
    root "static_page#home"
  end
end
