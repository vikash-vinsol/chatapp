class Socialize
  attr_accessor :pending_social1, :pending_social2

  def initialize(pending_social1, pending_social2)
    self.pending_social1 = pending_social1
    self.pending_social2 = pending_social2
  end

  def make_relationship
    social_relation = pending_social1.user.build_social_relation(socialize_with_id: pending_social2.user_id)
    begin
      ActiveRecord::Base.transaction do
        social_relation.save!
        pending_social1.destroy!
        pending_social2.destroy!
        pending_social1.user.notify_successful_socialization_with(pending_social2.user, pending_social2.content)
        pending_social2.user.notify_successful_socialization_with(pending_social1.user, pending_social1.content)
      end
    rescue StandardError => e
      pending_social1.handle_unsuccessful_connection
      pending_social2.handle_unsuccessful_connection
    end
  end
end