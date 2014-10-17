class Chat < ContentReceiver
  def self.with_user(content, user)
    begin
      transaction do
        content.save!
        push_content_to_users(content, user)
      end
    rescue StandardError => e
      content.errors.add(:base, "#{e}")
      return false
    end
    true
  end
end