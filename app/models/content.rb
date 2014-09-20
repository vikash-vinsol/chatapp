class Content < ActiveRecord::Base
  has_many :content_receivers, dependent: :destroy
  has_many :receivers, through: :content_receivers
  belongs_to :user

  has_attached_file :attachment,
                    url: 'public/attachment/:id/:style/:basename.:extension',
                    path: 'public/attachment/:id/:style/:basename.:extension'

  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :attachment, unless: :description?

  validates :user, presence: true
  validates :description, presence: true, if: Proc.new { attachment.blank? }

  after_update :destroy, if: Proc.new { receiver_count.zero? }

  def save_and_share_with_users(users)
    begin
      transaction do
        save!
        Share.content_with_users!(self, users)
      end
    rescue StandardError => e
      errors.add(:base, "#{e}")
      return false
    end
    true
  end

  def push_notify(users)
    # push content to user device
  end
end