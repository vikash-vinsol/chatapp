object @content

attributes :id, :description, :timer, :user

node(:attachment_url, :if => lambda { |content| content.attachment.present? }) do |content|
  content.attachment.url
end

child :user do
  attributes :account_name, :mobile, :firstname, :lastname
end