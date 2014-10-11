Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :countries, only: :index
      
      resources :users, only: :create do
        collection do
          get 'check_presence/:account_name', to: :check_presence
          get :users_by_phone
          get :friends_and_invitations
          get :friends_and_contacts
          put 'resend_verification_sms/:mobile', to: :resend_verification_sms
          put 'verify/:mobile/:verification_token', to: :verify
          post :send_friend_request
          post :friend_invitation_response
        end
      end

      resources :shares, only: [:create, :show]
    end
  end
end
