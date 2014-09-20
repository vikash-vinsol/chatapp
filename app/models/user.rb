class User < ActiveRecord::Base
  include Verification

  belongs_to :country

  validates :account_name, :firstname, :lastname, :country, :mobile, presence: true
  validates :device_type, :device_token, presence: true, if: :verified?
  validates :account_name, :mobile, :device_token, uniqueness: true
  validates :mobile, format: { with: /\d{10}/ }

  has_many :friend_invitations, foreign_key: :inviter_id
  has_many :friendships, foreign_key: :user_id

  scope :verified, -> { where(verified: true) }
  scope :with_account_name, ->(account_name) { where(account_name: account_name) }
  scope :with_device_token, ->(device_token) { where(device_token: device_token) }
  scope :with_mobiles, ->(mobiles) { where(mobile: mobiles) }

  def self.exist_with_account_name?(account_name)
    with_account_name(account_name).any?
  end

  def has_friend?(user)
    friendships.exist_with?(user)
  end

  def phone_with_country_code
    "#{country.mobile_code}#{mobile}"
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
      if((friend_invitation = friend_invitations.create(invitee_id: user.id)).errors.any?)
        [friend_invitation, FriendInvitation::RESPONSE_CODES[:error]]
      else
        [friend_invitation, FriendInvitation::RESPONSE_CODES[:sent]]
      end
    end
  end
end