module Api
  module V1
    class SharesController < BaseController
      before_action :load_verified_users_by_account_names, only: :create

      def create
        @content = Content.new(content_params)
        @content.user = current_user
        set_attachment_data_and_save
        Share.new(@content, @users).push
        respond_with(@content)
      end

      private
        def content_params
          params.require(:content).permit(:description, :timer)
        end

        def load_verified_users_by_account_names
          # only share with friends and verified users
          if (@users = current_user.friends.verified.where(account_name: params[:account_names] || params[:account_name])).blank?
            render status: 404, text: 'Receiver not found.'
          end
        end
    end
  end
end