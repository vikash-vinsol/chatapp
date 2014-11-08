module Api
  module V1
    class SharesController < BaseController
      before_action :load_users_by_mobile, only: :create

      def create
        @content = Content.new(content_params)
        @content.user = current_user
        Share.with_users(@content, @users)
        respond_with(@content)
      end

      private
        def content_params
          params.require(:content).permit(:description, :timer, :attachment)
        end

        def load_users_by_mobile
          # only share with friends and verified users
          if (@users = current_user.friends.verified.where(mobile: params[:mobiles] || params[:mobile])).blank?
            render status: 404, text: 'Receiver not found.'
          end
        end
    end
  end
end