Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :countries, only: :index
      
      resources :users, only: :create do
        collection do
          get 'check_presence/:account_name', to: :check_presence
          put 'resend_verification_sms/:mobile', to: :resend_verification_sms
          put 'verify/:mobile/:verification_token', to: :verify
          get 'users_by_phone', to: :users_by_phone
        end
      end
    end
  end
end
