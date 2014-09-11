class User < ActiveRecord::Base
  belongs_to :country

  validates :account_name, :firstname, :lastname, :country, :mobile, :device_type, :device_token, presence: true
  validates :account_name, :mobile, uniqueness: true
  validates :mobile, format: { with: /\d{10}/ }

  def self.exist_with_account_name?(account_name)
    find_by(account_name: account_name).present?
  end
end