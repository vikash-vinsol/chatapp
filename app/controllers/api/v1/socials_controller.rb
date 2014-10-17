module Api
  module V1
    class SocialsController < BaseController
      # before_action :load_socialized_user, only: :create

      # def create
      #   @content = Content.new(content_params)
      #   @content.user = current_user
      #   Socialize.with_user(@content, @user)
      #   respond_with(@content)
      # end

      # private
      #   def content_params
      #     params.require(:content).permit(:description, :attachment)
      #   end

      #   def load_socialize_with_user
      #     # only share with friends and verified users
      #     if (@user = current_user.socialized_user).blank?
      #       render status: 404, text: 'Receiver not found.'
      #     end
      #   end
    end
  end
end