node :friends do
  @friends.map do |user|
    partial("api/v1/users/show", object: user)
  end
end
