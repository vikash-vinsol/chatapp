class Content < ActiveRecord::Base
  belongs_to :user

  has_attached_file :attachment,
                    default_url: '',
                    url: 'content/:id/:style/:basename.:extension',
                    path: 'content/:id/:style/:basename.:extension',
                    storage: :s3,
                    s3_credentials: { bucket: ENV['AWS_BUCKET'], access_key_id: ENV['AWS_ACCESS_KEY'], secret_access_key: ENV['AWS_SECRET_TOKEN'] }

  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :attachment, unless: :description?

  validates :user, presence: true
  validates :description, presence: true, if: Proc.new { attachment.blank? }
  
  def attachment_url
    attachment.url if attachment.url.present?
  end

  def alert_desc
    "#{user.account_name}: #{description.truncate(20)}"
  end

  def set_attachment(encoded_image_data, image_format)
    decoded_data = Base64.decode64(encoded_image_data.gsub(/\\n/, "\n").gsub(' ', '+'))
    file = Tempfile.new(["temp#{DateTime.now.to_i}", ".#{image_format}"]) 
    file.binmode
    file.write decoded_data
    self.attachment = file
  end
end