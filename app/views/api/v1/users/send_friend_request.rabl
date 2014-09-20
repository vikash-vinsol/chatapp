node(:status, if: @status.present?) do
  @status
end

node(:errors, if: @friend_request.try(:errors).present?) do |friend_request|
  friend_request.errors
end