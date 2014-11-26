module Api
  module V1
    class SocialsController < BaseController
      def create
        current_user.social = params[:social]
        current_user.save
      end

      def create
        @content = Content.new(content_params)
        @content.user = current_user
        Socialize.with_user(@content, @user)
        respond_with(@content)
      end

      private
        def content_params
          params.require(:content).permit(:description, :attachment)
        end
    end
  end
end