Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development? || Rails.env.test?

  # Use environment variables in production (Heroku), fall back to credentials for local dev
  google_client_id = ENV['GOOGLE_CLIENT_ID'] || Rails.application.credentials.dig(:oauth, :google, :client_id)
  google_client_secret = ENV['GOOGLE_CLIENT_SECRET'] || Rails.application.credentials.dig(:oauth, :google, :client_secret)

  provider :google_oauth2, google_client_id, google_client_secret
end
