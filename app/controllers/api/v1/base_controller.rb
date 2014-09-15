module Api
  module V1
    class BaseController < ApplicationController
      layout false

      before_filter :authorize_request
      skip_before_filter :verify_authenticity_token

      respond_to :json

      private

        def authorize_request
          render(status: 401) unless(User.where(id: session[:user_id]).exist_with_verified_device?(current_device_token))
        end

        def current_device_type
          @current_device_type ||= DEVICE_TYPE[request.user_agent.to_s.downcase.scan(Regexp.new(DEVICE_TYPE.keys.join('|'))).first]
        end

        def current_device_token
          @current_device_token ||= request.headers['HTTP_DEVICE_TOKEN']
        end
    end
  end
end