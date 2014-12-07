module Socialization
  extend ActiveSupport::Concern

  included do
    scope :social, -> { where(social: true) }
    scope :not_socialized, -> { where(socialized: false) }
  end

  def find_socialized_user_id
    social_users_ids = where.not(id: self.id).verified.social.not_socialized.pluck(:id)
    social_users_ids.sample
  end
end