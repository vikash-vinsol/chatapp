collection @users

node(false) do |user|
  partial("api/v1/users/show", object: user)
end