module Socializtion
  extend ActiveSupport::Concern

  included do
    after_update :trigger_socialization, if: 'social_changed? && social?'
    after_update :clear_social_relation, if: 'social_changed? && !social?'

    scope :social, -> { where(social: true) }
    scope :not_socialized, -> { where(socialized: false) }
  end

  def find_socialized_user_id
    social_users_ids = where.not(id: self.id).verified.social.not_socialized.pluck(:id)
    social_users_ids.sample
  end

  private

    def clear_social_relation
      social_relation.try(:destroy)
    end

    def trigger_socialization
      if reload.social? && !socialized?
        try_count = 1
        while try_count <= 5
          social_user_id = find_socialized_user_id
          social_relation = build_social_relation(socialize_with_id: social_user_id)
          begin
            social_relation.save!
          rescue StandardError => e
            try_count += 1
          end
        end

        if try_count > 5
          #push to user that socialized with user not found
        end
      end
    end

    # handle_asynchronously :trigger_socialization
end