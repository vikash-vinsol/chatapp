module Api
  module V1
    class SocialsController < BaseController
      def create
        @content = Content.new(content_params)
        @content.user = current_user
        if((encoded_image_data = params[:content][:encoded_image_data]).present?)
          @content.set_attachment(encoded_image_data, params[:content][:image_format])
        end
        if(current_user.socialized?)
          @status = User::SOCIALIZE_RESPONSE_CODES[:already_socialized]
        elsif(@content.save)
          PendingSocial.create(user_id: current_user.id, content_id: @content.id)
          @status = User::SOCIALIZE_RESPONSE_CODES[:success]
        else
          @status = User::SOCIALIZE_RESPONSE_CODES[:failure]
        end
      end

      def destroy
        if(social_relation = SocialRelation.find_by_user_id(current_user.id) && social_relation.destroy)
          @destroyed_status = 1
        else
          @destroyed_status = 0
        end
      end

      private
        def content_params
          params.require(:content).permit(:description, :timer)
        end
    end
  end
end