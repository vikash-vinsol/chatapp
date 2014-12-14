module Api
  module V1
    class ChatsController < BaseController
      before_action :load_verified_user_by_account_name, only: :create

      def create
        @content = Content.new(content_params)
        @content.user = current_user
        set_attachment_data_and_save
        Chat.new(@content, @user).push
        respond_with(@content)
      end

      private
        def content_params
          params.require(:content).permit(:description)
        end

        def load_verified_user_by_account_name
          # only chat with friends.verified user or socialized user
          # TODO : for socialized user
          if (@user = current_user.friends.verified.where(account_name: params[:account_name])).blank?
            render status: 404, text: 'Receiver not found.'
          end
        end
    end
  end
end