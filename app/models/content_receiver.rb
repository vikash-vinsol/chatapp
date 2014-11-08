class ContentReceiver < ActiveRecord::Base
  belongs_to :receiver, class_name: 'User'
  belongs_to :content, class_name: 'Content'

  validates :content, :receiver, presence: true
  validates :content_id, uniqueness: { scope: :receiver_id }

  after_create { update_content_receiver_count(1) }
  after_destroy { update_content_receiver_count(-1) }

  def self.push_content_to_users(content, users)
    if users.present?
      users = [users] if users.is_a?(User)
      users.each do |user|
        create!(content_id: content.id, receiver_id: user.id)
      end
      content.push_notify
      content.destroy if content.attachment_url.blank?
    else
      content.errors.add(:base, 'Receiver not present')
    end
  end

  private
    def update_content_receiver_count(counter)
      Content.update_counters(content_id, receiver_count: counter)
    end
end