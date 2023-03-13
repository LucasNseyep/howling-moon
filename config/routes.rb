Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :thoughts do
    member do
      post :connect
      post :disconnect
    end
  end

  resources :collections

  get "/thoughts/:id/browse", to: "thoughts#browse", as: :browse_thoughts
end
