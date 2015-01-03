class Socialize < ContentReceiver
  def create_session
    from_user.social = true
    delay.trigger(from_user.id) if from_user.save
  end

  def trigger(from_user_id)
    from_user = User.find_by_id(from_user_id)
    if(from_user.social? && !from_user.socialized?)
      try_count = 1
      successfully_socialized = false
      start_time = Time.current
      while(!successfully_socialized && from_user.social? && !from_user.socialized? && (try_count <= 5 ||  (Time.current - start_time).seconds <= 30))
        from_user = User.find_by_id(from_user_id)
        if(social_user_id = User.find_socialized_user_id(from_user.id))
          social_relation = from_user.build_social_relation(socialize_with_id: social_user_id)
          begin
            successfully_socialized = social_relation.save!
            self.receivers = [from_user.socialize_with]
            User.notify_successfull_socialization_between(from_user, from_user.socialize_with)
            from_user.reload
          rescue StandardError => e
            try_count += 1
            from_user.reload
          end
        else
          try_count += 1
          from_user.reload
        end
      end

      from_user.notify_unsuccessfull_socialization_between if try_count > 5
    end
  end

  # handle_asynchronously :trigger

  def destroy_session
    from_user.social = false
    if from_user.save && social_relation.try(:destroy)
      self.receivers = [from_user.socialize_with]
      push
    else

    end
    from_user.social = false
    begin
      transaction do
        from_user.save!
        self.receivers = [from_user.socialize_with]
        from_user.social_relation.try(:destroy!)
      end
    rescue StandardError => e
      self.attributes = parameters
      copy_errors_from(new_address) if(errors.empty?)
      false
    end
  end
end