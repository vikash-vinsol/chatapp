#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  if((pending_socials = PendingSocial.where(true).order('id asc').limit(2)).length == 2)
    Socialize.new(pending_socials[0], pending_socials[1]).make_relationship
  elsif(pending_socials.length == 1 && (Time.current - (pending_social = pending_socials.first).created_at).seconds >= 30)
    pending_social.handle_unsuccessful_connection
  end

  sleep 2
end
