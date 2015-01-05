class PendingSocial < ActiveRecord::Base
  belongs_to :user
  belongs_to :content

  validates :user, presence: true
  validates :content, presence: true
  validates :user_id, uniqueness: true
  validates :content_id, uniqueness: true

  def handle_unsuccessful_connection
    device_infos = { type: user.device_type, token: user.device_token }
    data = { push_type: PUSH_NOTIFICATION_TYPES[:unsuccessful_socialization], description: 'Cannot be socialized' }
    PushNotification.new([device_infos], data, 'Cannot be socialized').send
    destroy
  end
end