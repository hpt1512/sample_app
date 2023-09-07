Rails.application.routes.draw do
  get 'relationship/create'
  get 'relationship/destroy'
  root "static_pages#home"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :products
  get "static_pages/home"
  get "static_pages/help"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users
  resources :password_resets, only: %i(new create edit update)

  resources :account_activations, only: :edit

  resources :microposts, only: %i(create destroy)

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: %i(create destroy)
end
