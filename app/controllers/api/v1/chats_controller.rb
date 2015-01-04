module Api
  module V1
    class ChatsController < BaseController
      before_action :load_verified_user_by_account_name, only: :create
      before_action :load_socialized_user, only: :with_socialized_user

      def create
        save_content
        respond_with(@content)
      end

      def with_socialized_user
        save_content
        render 'create'
      end

      private
        def content_params
          params.require(:content).permit(:description)
        end

        def load_socialized_user
          render status: 404, text: 'Receiver not found.' unless(@user = current_user.socialize_with)
        end

        def load_verified_user_by_account_name
          if (@user = current_user.friends.verified.where(account_name: params[:account_name])).blank?
            render status: 404, text: 'Receiver not found.'
          end
        end

        def save_content
          @content = Content.new(content_params)
          @content.user = current_user
          set_attachment_data_and_save
          Chat.new(@content, @user).push
        end
    end
  end
end