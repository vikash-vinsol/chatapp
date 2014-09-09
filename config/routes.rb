Rails.application.routes.draw do
  resources :countries, only: :index
  resources :users do
    get :check_presence, on: :collection
  end
end
