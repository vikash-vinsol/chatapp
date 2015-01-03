module Api
  module V1
    class SocialsController < BaseController
      def create
        @content = Content.new(content_params)
        @content.user = current_user
        if((encoded_image_data = params[:content][:encoded_image_data]).present?)
          @content.set_attachment(encoded_image_data, params[:content][:image_format])
        end
        Socialize.new(@content).create_session if(@content.save)
        respond_with(@content)
      end

      def destroy
        content = Content.new(description: 'No more socialized', user: current_user)
        Socialize.new(content).destroy_session
        respond_with(current_user)
      end

      private
        def content_params
          params.require(:content).permit(:description, :timer)
        end
    end
  end
end