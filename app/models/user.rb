class User < ActiveRecord::Base
  include Verification

  belongs_to :country

  validates :account_name, :firstname, :lastname, :country, :mobile, presence: true
  validates :device_type, :device_token, presence: true, if: :verified?
  validates :account_name, :mobile, :device_token, uniqueness: true
  validates :mobile, format: { with: /\d{10}/ }

  scope :verified, -> { where(verified: true) }
  scope :with_account_name, ->(account_name) { where(account_name: account_name) }
  scope :with_device_token, ->(device_token) { where(device_token: device_token) }

  def self.exist_with_account_name?(account_name)
    with_account_name(account_name).any?
  end

  def self.exist_with_verified_device_token?(device_token)
    with_device_token(device_token).verified.any?
  end

  def phone_with_country_code
    "#{country.mobile_code}#{mobile}"
  end
end