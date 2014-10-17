module Api
  module V1
    class ChatsController < BaseController
      before_action :load_user_by_mobile, only: :create

      def create
        @content = Content.new(content_params)
        @content.user = current_user
        Chat.with_user(@content, @user)
        respond_with(@content)
      end

      private
        def content_params
          params.require(:content).permit(:description, :attachment)
        end

        def load_user_by_mobile
          # only chat with friends.verified user or socialized user
          # TODO : for socialized user
          if (@user = current_user.friends.verified.where(mobile: params[:mobile])).blank?
            render status: 404, text: 'Receiver not found.'
          end
        end
    end
  end
end