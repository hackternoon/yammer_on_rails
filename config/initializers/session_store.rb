# Be sure to restart your server when you modify this file.

Yam::Application.config.session_store :cookie_store, key: '_yam_session', :secret => 'j0esm1thjoesmith'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Yam::Application.config.session_store :active_record_store
