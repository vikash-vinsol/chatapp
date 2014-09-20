class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: User

  validates :user, :friend, presence: true
  validates :user_id, uniqueness: { scope: :friend_id }
  scope :exist_with, ->(user) { where(friend_id: user.id) }

  def self.exist_with?(user)
    exist_with(user).any?
  end
end