class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: User

  validates :user, :friend, presence: true
  validates :user_id, uniqueness: { scope: :friend_id }
  scope :exist_with, ->(user) { where(friend_id: user.id) }
  after_create :after_friendship_tasks

  def after_friendship_tasks
    if(user.friend_invitations.find_by_invitee_id(friend_id).try(:destroy))
      Friendship.create_without_validation_and_callback(friend_id, user_id)
      'push notification to (user) about friend request accepted of (friend)'
    else
      raise ActiveRecord::Rollback
    end
  end

  def self.create_without_validation_and_callback(user_id, friend_id)
    current_time = DateTime.current.to_s(:db)
    ActiveRecord::Base.connection.execute("INSERT INTO friendships (user_id, friend_id, created_at, updated_at) VALUES(#{user_id}, #{friend_id}, '#{current_time}', '#{current_time}')")
  end

  def self.exist_with?(user)
    exist_with(user).any?
  end
end