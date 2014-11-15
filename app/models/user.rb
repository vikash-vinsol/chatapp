class User < ActiveRecord::Base
  include Verification

  has_many :content_receivers, foreign_key: :receiver_id, dependent: :destroy
  has_many :pending_contents, class_name: 'Content', through: :content_receivers, source: :content
  has_many :contents, dependent: :destroy

  belongs_to :country

  validates :account_name, :firstname, :lastname, :country, :mobile, presence: true
  validates :device_type, :device_token, presence: true, if: :verified?
  validates :device_token, uniqueness: true, if: :verified?
  validates :account_name, :mobile, uniqueness: true
  validates :mobile, format: { with: /\d{10}/ }

  has_many :friend_invitations, foreign_key: :inviter_id
  has_many :friend_invitations_received, foreign_key: :invitee_id, class: FriendInvitation
  has_many :friendships, foreign_key: :user_id
  has_many :friends, through: :friendships, source: :friend
  has_many :friend_invitations_sent_to, through: :friend_invitations, source: :invitee
  has_many :friend_invitations_received_by, through: :friend_invitations_received, source: :inviter

  scope :verified, -> { where(verified: true) }
  scope :with_account_name, ->(account_name) { where(account_name: account_name) }
  scope :with_device_type, ->(device_type) { where(device_type: device_type) }
  scope :with_device_token, ->(device_token) { where(device_token: device_token) }
  scope :with_mobiles, ->(mobiles) { where(mobile: mobiles) }

  def self.exist_with_account_name?(account_name)
    with_account_name(account_name).any?
  end

  def handle_friend_invitation_response(inviter, status)
    friend_invitation = inviter.friend_invitations.find_by_invitee_id(id)

    if(friend_invitation.present?)
      friend_invitation.accept_or_reject(status)
    else
      FriendInvitation::RESPONSE_CODES[:not_exist]
    end
  end

  def has_friend?(user)
    friendships.exist_with?(user)
  end

  def make_friends_with(mobiles)
    User.verified.with_mobiles(mobiles).select do |user|
      friendship = friendships.new(friend_id: user.id, without_friend_invitation: true)
      friendship.save
    end
  end

  def phone_with_country_code
    "#{country.mobile_code}#{mobile}"
  end

  def send_accept_or_reject_invitation_of(user, status)
    inviter_device = { type: user.device_type, token: user.device_token }
    invitee_account_name = account_name
    data = { invitee_account_name: invitee_account_name }
    message = "#{invitee_account_name} #{status} your invitation"
    PushNotification.new([inviter_device], data, message).send
  end

  def friend_invitation_pending_with?(user)
    FriendInvitation.pending_between?(self, user)
  end

  def send_friend_invitation_to(user)
    if(has_friend?(user))
      [nil, FriendInvitation::RESPONSE_CODES[:existing_friend]]
    elsif(friend_invitation_pending_with?(user))
      [nil, FriendInvitation::RESPONSE_CODES[:pending]]
    else
      friend_invitation = friend_invitations.new(invitee_id: user.id)
      if(friend_invitation.save)
        [friend_invitation, FriendInvitation::RESPONSE_CODES[:success]]
      else
        [friend_invitation, FriendInvitation::RESPONSE_CODES[:failure]]
      end
    end
  end
end