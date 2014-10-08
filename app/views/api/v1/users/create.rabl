object @user

attributes :id, :account_name, :firstname, :lastname, :mobile, :country_id, :verification_token

node(:errors, :if => lambda { |user| user.errors.present? }) do |user|
  user.errors
end