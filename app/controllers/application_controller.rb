class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  respond_to :json

  private

    def current_device_type
      @current_device_type ||= DEVICE_TYPE[request.user_agent.to_s.downcase.scan(Regexp.new(DEVICE_TYPE.keys.join('|'))).first]
    end

    def current_device_token
      @current_device_token ||= request.headers['HTTP_DEVICE_TOKEN']
    end
end
