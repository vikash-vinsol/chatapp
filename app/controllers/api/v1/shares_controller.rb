module Api
  module V1
    class SharesController < BaseController
      before_action :load_users_by_mobile, only: :create
      before_action :load_content, only: :show

      def create
        @content = Content.new(content_params)
        @content.user = current_user
        @content.save_and_share_with_users(@users)
        respond_with(@content)
      end

      def show
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

        def load_content
          unless (@content = current_user.pending_contents.find_by(id: params[:content_id]))
            render status: 404, text: 'Content not found.'
          end
        end
    end
  end
end