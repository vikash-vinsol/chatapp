class FriendInvitation < ActiveRecord::Base
  RESPONSE_CODES = { sent: '0', pending: '1', existing_friend: '2', error: '3' }

  belongs_to :inviter, class_name: User
  belongs_to :invitee, class_name: User

  validates :inviter, :invitee, presence:true
  validates :inviter_id, uniqueness: { scope: :invitee_id, message: 'invitation pending'  }

  after_create :send_friend_invitation

  def self.pending_between?(user1, user2)
    where("(inviter_id = #{user1.id} AND invitee_id = #{user2.id}) OR (inviter_id = #{user2.id} AND invitee_id = #{user1.id})").any?
  end

  def send_friend_invitation
    p 'Send friend invitation using push notification'
  end
end