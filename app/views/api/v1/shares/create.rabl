object @content

attributes :id, :description, :timer

node(:attachment_url, :if => lambda { |content| content.attachment.present? }) do |content|
  content.attachment.url
end

node(:errors, :if => lambda { |content| content.errors.present? }) do |content|
  content.errors
end