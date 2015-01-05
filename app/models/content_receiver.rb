class ContentReceiver
  attr_accessor :content, :receivers, :from_user

  def initialize(content, receivers=[])
    @content = content
    @receivers = receivers.is_a?(User) ? [receivers] : receivers
    @from_user = content.user
  end

  def push
    if receivers.present?
      device_infos = receivers.map { |receiver| { type: receiver.device_type, token: receiver.device_token } }
      data = { push_type: PUSH_NOTIFICATION_TYPES[:share_or_chat], description: content.description, attachment_url: content.attachment_url, timer: content.timer, from: from_user.account_name }
      PushNotification.new(device_infos, data, content.alert_desc).send
    else
      content.errors.add(:base, 'Receiver not present')
    end
  end
end