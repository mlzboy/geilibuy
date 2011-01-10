# Be sure to restart your server when you modify this file.

B2c2::Application.config.session_store :cookie_store, :key => '_b2c2_session',:domain=>".geilibuy.com"
 #Rails.application.config.session_store :cookie_store, :key => '_app_session', :domain => ".google.co.uk"

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
 #B2c2::Application.config.session_store :active_record_store
