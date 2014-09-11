module Verification
  extend ActiveSupport::Concern

  included do
    before_create :assign_verification_details
    after_save :perform_verification_process, if: :verification_token_changed?
  end

  private
    def assign_verification_details
      self.verification_token = generate_verification_token
      self.verified = false
      self.verification_expired = false
      true
    end

    def expire_verification_token(user_id)
      user = User.where(id: user_id).first
      user.update_column(:verification_expired, true) unless(user.verified?)
    end

    def generate_verification_token
      rand(10000..99999)
    end

    def perform_verification_process
      Sms.deliver(phone_with_country_code, "Verification Token: #{verification_token}")
      delay(run_at: 1.minutes.from_now).expire_verification_token(id)
    end
end