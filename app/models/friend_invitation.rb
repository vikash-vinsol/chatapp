class FriendInvitation < ActiveRecord::Base
  RESPONSE_CODES = { success: '0', existing_friend: '1', failure: '2', not_exist: '3', pending: '4' }
  STATUS = { pending: '0', accept: '1', reject: '2' }

  belongs_to :inviter, class_name: User
  belongs_to :invitee, class_name: User

  validates :inviter, :invitee, presence:true
  validates :inviter_id, uniqueness: { scope: :invitee_id, message: 'invitation pending'  }

  after_create :send_friend_invitation

  class << self
    FriendInvitation::STATUS.each do |key, value|
      define_method "#{key}_status?" do |status|
        value == status
      end
    end
  end

  def self.pending_between?(user1, user2)
    where("(inviter_id = #{user1.id} AND invitee_id = #{user2.id}) OR (inviter_id = #{user2.id} AND invitee_id = #{user1.id})").any?
  end

  def send_friend_invitation
    p 'Send friend invitation (phone_no, username) using push notification'
  end

  def accept_or_reject(status)
    if(FriendInvitation.accept_status?(status))
      accept
    elsif(FriendInvitation.reject_status?(status))
      reject
    end
  end

  def accept
    begin
      inviter.friendships.create!(friend_id: invitee_id)
      FriendInvitation::RESPONSE_CODES[:success]
    rescue StandardError => e
      FriendInvitation::RESPONSE_CODES[:failure]
    end
  end

  def reject
    if(destroy)
      FriendInvitation::RESPONSE_CODES[:success]
      'push to (user) that friend request of(self) has been rejected'
    else
      FriendInvitation::RESPONSE_CODES[:failure]
    end
  end
end