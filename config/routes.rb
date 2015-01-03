Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :countries, only: :index
      
      resources :users, only: [:create, :show] do
        collection do
          get 'check_presence/:account_name', to: :check_presence
          get :send_installation_sms
          post :friends_and_contacts
          post :send_friend_request
          post :friend_invitation_response
          put 'resend_verification_sms/:mobile', to: :resend_verification_sms
          put 'verify/:mobile/:verification_token', to: :verify
        end
      end

      resources :shares, only: :create
      resources :chats, only: :create do
        post :with_socialized_user
      end
      resources :socials, only: [:create, :destroy]
    end
  end
end
