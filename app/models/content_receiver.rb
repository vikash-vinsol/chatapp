class ContentReceiver < ActiveRecord::Base
  belongs_to :receiver, class_name: 'User'
  belongs_to :content, class_name: 'Content'

  validates :content, :receiver, presence: true
  validates :content_id, uniqueness: { scope: :receiver_id }

  after_create { update_content_receiver_count(1) }
  after_destroy { update_content_receiver_count(-1) }

  private
    def update_content_receiver_count(counter)
      Content.update_counters(content_id, receiver_count: counter)
    end
end