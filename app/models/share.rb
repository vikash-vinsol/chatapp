class Share < ContentReceiver
  def self.content_with_users!(content, users)
    users.each do |user|
      create!(content_id: content.id, receiver_id: user.id)
    end
    content.push_notify(users)
  end
end