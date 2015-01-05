module Socialization
  extend ActiveSupport::Concern

  included do
    SOCIALIZE_RESPONSE_CODES = { success: '0', already_socialized: '1', failure: '2' }
    has_one :social_relation
    has_one :socialize_with, through: :social_relation
  end

  def notify_successful_socialization_with(user, content)
    device = { type: device_type, token: device_token }
    socialize_with_user = user.account_name
    data = { push_type: PUSH_NOTIFICATION_TYPES[:successful_socialization], description: content.description, attachment_url: content.attachment_url, timer: content.timer, socialize_with_user: socialize_with_user }
    message = "You have been socialized with #{socialize_with_user}"
    PushNotification.new([device], data, message).send
  end
end