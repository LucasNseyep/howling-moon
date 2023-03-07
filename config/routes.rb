Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :thoughts, only: [:index, :show] do
    member do
      post :connect
      post :disconnect
    end
  end

  get "/thoughts/:id/browse", to: "thoughts#browse", as: :browse_thoughts
end
