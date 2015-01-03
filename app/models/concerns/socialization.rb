module Socialization
  extend ActiveSupport::Concern

  included do
    has_one :social_relation
    has_one :socialize_with, through: :social_relation

    scope :social, -> { where(social: true) }
    scope :not_socialized, -> { where(socialized: false) }
    scope :socialized, -> { where(socialized: true) }
  end

  module ClassMethods
        
    def notify_successfull_socialization_between(user1, user2)
      p 'hi' * 80
      p user1
      p user2
      p 'hi2' * 80
      user1.notify_successfull_socialization_with(user2)
      user2.notify_successfull_socialization_with(user1)
    end

    def find_socialized_user_id(user_id)
      social_users_ids = User.where.not(id: user_id).verified.social.not_socialized.pluck(:id)
      social_users_ids.sample
    end

  end

  def notify_unsuccessfull_socialization_between
    device_infos = { type: device_type, token: device_token }
    data = { description: 'Cannot be socialized' }
    PushNotification.new([device_infos], data, 'Cannot be socialized').send
  end

  def notify_successfull_socialization_with(user)
    device = { type: device_type, token: device_token }
    socialize_with_user = user.account_name
    data = { socialize_with_user: socialize_with_user }
    message = "You have been socialized with #{socialize_with_user}"
    PushNotification.new([device], data, message).send
  end
end