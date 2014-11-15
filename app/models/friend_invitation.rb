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
    invitee_device = { type: invitee.device_type, token: invitee.device_token }
    inviter_account_name = inviter.account_name
    data = { inviter_account_name: inviter_account_name }
    message = "#{inviter_account_name} invited you"
    PushNotification.new([invitee_device], data, message).send
  end

  def accept_or_reject(status)
    if(FriendInvitation.accept_status?(status))
      accept
    elsif(FriendInvitation.reject_status?(status))
      reject
    end
  end

  def accept
    friendship = inviter.friendships.new(friend_id: invitee_id)
    friendship.save ? FriendInvitation::RESPONSE_CODES[:success] : FriendInvitation::RESPONSE_CODES[:failure]
  end

  def reject
    if(destroy)
      FriendInvitation::RESPONSE_CODES[:success]
      invitee.send_accept_or_reject_invitation_of(inviter, 'rejects')
    else
      FriendInvitation::RESPONSE_CODES[:failure]
    end
  end
end