Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :countries, only: :index
      
      resources :users, only: :create do
        get :check_presence, on: :collection
      end
    end
  end
end
