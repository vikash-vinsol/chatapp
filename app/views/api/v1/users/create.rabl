object(@user)

node(false) do
  partial("api/v1/users/show", object: @user)
end

node(:errors, :if => lambda { |user| user.errors.present? }) do |user|
  user.errors
end