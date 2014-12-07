class Content < ActiveRecord::Base
  belongs_to :user

  has_attached_file :attachment,
                    default_url: '',
                    url: 'public/attachment/:id/:style/:basename.:extension',
                    path: 'public/attachment/:id/:style/:basename.:extension'

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
end