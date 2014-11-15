node :friends do
  (@old_friends + @new_friends).map do |user|
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

node(:other_mobiles) do
  @other_mobiles
end