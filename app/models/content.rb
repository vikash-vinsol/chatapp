class Content < ActiveRecord::Base
  has_many :content_receivers, dependent: :destroy
  has_many :receivers, through: :content_receivers
  belongs_to :user

  has_attached_file :attachment,
                    default_url: '',
                    url: 'public/attachment/:id/:style/:basename.:extension',
                    path: 'public/attachment/:id/:style/:basename.:extension'

  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :attachment, unless: :description?

  validates :user, presence: true
  validates :description, presence: true, if: Proc.new { attachment.blank? }

  after_update :destroy, if: Proc.new { receiver_count.zero? }

  def push_notify
    device_infos = receivers.map { |user| {type: user.device_type, token: user.device_token} }
    data = { description: description, attachment_url: attachment_url, timer: timer, from: user.mobile }
    PushNotification.new(device_infos, data, alert_desc).send
  end

  def attachment_url
    attachment.url if attachment.url.present?
  end

  def alert_desc
    "#{user.mobile}: #{description.truncate(20)}"
  end
end