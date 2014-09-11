module Api
  module V1
    class UsersController < BaseController
      def check_presence
        @user_exist = User.exist_with_account_name?(params[:account_name])
      end
    end
  end
end