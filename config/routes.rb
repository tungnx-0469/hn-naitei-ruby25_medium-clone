Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: {
      registrations: "users/registrations"
    }
    get "profile/:id", to: "profile#show", as: "profile"
    root "static_page#home"
  end
end
