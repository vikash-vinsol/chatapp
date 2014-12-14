module Api
  module V1
    class BaseController < ApplicationController
      layout false

      before_filter :authorize_request
      skip_before_filter :verify_authenticity_token

      respond_to :json

      private

        def authorize_request
          render(status: 401, text: 'Request not authorised.') unless(current_user)
        end

        def current_device_type
          @current_device_type ||= DEVICE_TYPE[request.user_agent.to_s.downcase.scan(Regexp.new(DEVICE_TYPE.keys.join('|'))).first]
        end

        def current_device_token
          @current_device_token ||= request.headers['HTTP_DEVICE_TOKEN']
        end

        def current_user
          @current_user ||= User.verified.with_device_token(current_device_token).find_by(id: session[:user_id])
        end

        def set_attachment_data_and_save
          if((encoded_image_data = params[:content][:encoded_image_data]).present?)
            @content.set_attachment(encoded_image_data, params[:content][:image_format])
            @content.save
          end
        end
    end
  end
end