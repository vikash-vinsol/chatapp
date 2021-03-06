class PushNotification
  APPS = { 'iphone' => Rpush::Apns::App.find_by_name("ios_app"), 'android' => Rpush::Gcm::App.find_by_name("android_app") }

  attr_accessor :device_tokens, :data, :message

  def initialize(devices_info, data, message)
    self.device_tokens = find_device_tokens(devices_info)
    self.data = data
    self.message = message
  end

  def find_device_tokens(devices_info)
    Hash[devices_info.group_by { |device_info| device_info[:type] }.map { |type, devices_info| [DEVICE_TYPE.key(type), devices_info.map { |device_info| device_info[:token] }] }]
  end

  def send
    send_with_apns if(device_tokens['iphone'].present?)
    send_with_gcm if(device_tokens['android'].present?)
  end

  def send_with_apns
    device_tokens['iphone'].each do |device_token|
      Rpush::Apns::Notification.create!(app: APPS['iphone'], device_token: device_token, alert: message, data: data)
    end
  end

  def send_with_gcm
    Rpush::Gcm::Notification.create!(app: APPS['android'], registration_ids: [device_tokens['android'].first], data: data.merge({ message: message }))
  end
end