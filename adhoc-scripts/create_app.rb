require File.expand_path(File.join(File.dirname(__FILE__), '../config', 'environment'))

#ios_app
app = Rpush::Apns::App.where(name: 'ios_app').first_or_initialize
app.certificate = File.read("config/apple_notification.pem")
app.environment = ENV['apple_notification_environment'] # APNs environment.
app.password = ENV['apple_notification_password']
app.connections = 1
app.save!