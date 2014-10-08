# Be sure to restart your server when you modify this file.

SESSION_NAME = "#{Rails.env.production? ? '' : '_'+Rails.env }_chatapp_session"
Rails.application.config.session_store :active_record_store, key: SESSION_NAME
