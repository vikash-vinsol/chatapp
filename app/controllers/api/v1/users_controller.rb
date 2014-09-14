module Api
  module V1
    class UsersController < BaseController
      before_filter :load_user, only: [:resend_verification_sms, :verify]

      def create
        @user = User.create(user_params)
        respond_with(@user)
      end

      def check_presence
        @user_exist = User.exist_with_account_name?(params[:account_name])
      end

      def resend_verification_sms
        @user.regenerate_verification_token
        respond_with(@user)
      end

      def verify
        @status = @user.verify(params[:verification_token], current_device_type, current_device_token)
        respond_with(@user)
      end

      private
        def load_user
          render(status: 404) unless(@user = User.find_by_mobile(params[:mobile]))
        end

        def user_params
          params.require(:user).permit(:account_name, :firstname, :lastname, :country_id, :mobile)
        end
    end
  end
end