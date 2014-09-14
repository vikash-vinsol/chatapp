module Verification
  extend ActiveSupport::Concern

  included do
    VERIFY_STATUS = { verified: 0, invalid: 1, expired: 2 }

    before_create :generate_verification_token, :set_verification_token_sent_at
    before_update :set_verification_token_sent_at, if: :verification_token_changed?
    after_save :send_verification_token, if: :verification_token_changed?
  end

  def has_verification_token?(verification_token)
    self.verification_token == verification_token
  end

  def regenerate_verification_token
    generate_verification_token
    save
  end

  def save_verified_device(device_type, device_token)
    self.verified = true
    self.device_type = device_type
    self.device_token = device_token
    save
  end

  def verification_token_expired?
    (DateTime.current - 3.minutes) >= verification_token_sent_at
  end

  def verify(verification_token, device_type, device_token)
    if(verification_token_expired?)
      VERIFY_STATUS[:expired]
    elsif(has_verification_token?(verification_token))
      save_verified_device(device_type, device_token)
      VERIFY_STATUS[:verified]
    else
      VERIFY_STATUS[:invalid]
    end
  end

  private

    def generate_verification_token
      self.verification_token = rand(10000..99999)
    end

    def set_verification_token_sent_at
      self.verification_token_sent_at = DateTime.current
    end

    def send_verification_token
      Sms.delay.deliver(phone_with_country_code, "Verification Token: #{verification_token}")
    end
end