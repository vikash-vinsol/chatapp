class Share < ContentReceiver
  def self.with_users(content, users)
    begin
      transaction do
        content.save!
        push_content_to_users(content, users)
      end
    rescue StandardError => e
      content.errors.add(:base, "#{e}")
      return false
    end
    true
  end
end