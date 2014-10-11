node :friends do
  @friends.map do |user|
    partial("api/v1/users/show", object: user)
  end
end

node :friend_invitations_sent_to do
  @friend_invitations_sent_to.map do |user|
    partial("api/v1/users/show", object: user)
  end
end

node :friend_invitations_received_by do
  @friend_invitations_received_by.map do |user|
    partial("api/v1/users/show", object: user)
  end
end

node(:users) do
  @users.map do |user|
    partial("api/v1/users/show", object: user)
  end
end

node(:others) do
  @others
end