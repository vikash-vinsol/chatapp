class SocialRelation < ActiveRecord::Base
  belongs_to :socialize_with, class_name: 'User'

  after_create :create_couple_and_socialize
  after_destroy :delete_couple

  private
    def create_couple_and_socialize
      current_time = DateTime.current.to_s(:db)
      ActiveRecord::Base.connection.execute("INSERT INTO social_relations (user_id, socialize_with_id, created_at, updated_at) VALUES(#{socialize_with_id}, #{user_id}, '#{current_time}', '#{current_time}')")
      User.update_all('socialized = true', "id IN (#{user_id}, #{socialize_with_id})")
    end

    def delete_couple
      SocialRelation.find_by_user_id(socialized_with_id).delete
      User.update_all('socialized = false, social = false', "id IN (#{user_id}, #{socialize_with_id})")
    end
end