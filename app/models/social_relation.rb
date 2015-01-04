class SocialRelation < ActiveRecord::Base
  belongs_to :socialize_with, class_name: 'User'

  validates :user_id, uniqueness: true
  validates :socialize_with_id, uniqueness: true
  validate :check_self_socialize
  
  after_create :create_couple_and_socialize
  after_destroy :delete_couple_and_notify

  private
    def check_self_socialize
      errors.add(:user_id, 'should not equal to socialize_with_id') if(user_id == socialize_with_id)
    end

    def create_couple_and_socialize
      current_time = DateTime.current.to_s(:db)
      ActiveRecord::Base.connection.execute("INSERT INTO social_relations (user_id, socialize_with_id, created_at, updated_at) VALUES(#{socialize_with_id}, #{user_id}, '#{current_time}', '#{current_time}')")
      User.where(id: [user_id, socialize_with_id]).update_all(socialized: true)
    end

    def delete_couple_and_notify
      if(coupled_social_relation = SocialRelation.find_by_user_id(socialize_with_id))
        socialize_with_user = socialize_with
        coupled_social_relation.delete
        User.where(id: [user_id, socialize_with_id]).update_all(socialized: false)
        device_infos = { type: socialize_with_user.device_type, token: socialize_with_user.device_token }
        data = { description: 'Your socialized partner has left' }
        PushNotification.new([device_infos], data, 'Your socialized partner has left').send
      end
    end
end