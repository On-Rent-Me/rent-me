Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development? || Rails.env.test?

  # Use environment variables in production (Heroku), fall back to credentials for local dev
  google_client_id = ENV['GOOGLE_CLIENT_ID'] ||
                     Rails.application.credentials.dig(:oauth, :google, :client_id) ||
                     Rails.application.credentials.dig(Rails.env.to_sym, :oauth, :google, :client_id)

  google_client_secret = ENV['GOOGLE_CLIENT_SECRET'] ||
                         Rails.application.credentials.dig(:oauth, :google, :client_secret) ||
                         Rails.application.credentials.dig(Rails.env.to_sym, :oauth, :google, :client_secret)

  if google_client_id.present? && google_client_secret.present?
    provider :google_oauth2, google_client_id, google_client_secret,
      prompt: 'select_account'
  else
    Rails.logger.warn "Google OAuth credentials not found. Please set GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET environment variables or add them to credentials."
  end
end
