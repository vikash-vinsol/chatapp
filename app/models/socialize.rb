class Socialize < ContentReceiver
  def create_session
    from_user.social = true
    trigger if from_user.save
  end

  def trigger
    if from_user.reload.social? && !from_user.socialized?
      try_count = 1
      while try_count <= 5
        social_user_id = from_user.find_socialized_user_id
        social_relation = from_user.build_social_relation(socialize_with_id: social_user_id)
        begin
          social_relation.save!
          self.receivers = [User.find_by(id: social_user_id)]
          push
        rescue StandardError => e
          try_count += 1
        end
      end

      if try_count > 5
        device_infos = { type: from_user.device_type, token: from_user.device_token }
        data = { description: 'Cannot be socialized' }
        PushNotification.new(device_infos, data, 'Cannot be socialized').send
      end
    end
  end

  # handle_asynchronously :trigger

  def destroy_session
    from_user.social = false
    if from_user.save
      self.receivers = [from_user.socialize_with]
      social_relation.try(:destroy)
      push
    end
  end
end