# QuickBooks API Configuration
#
# Required environment variables:
# - QUICKBOOKS_CLIENT_ID: Your QuickBooks app client ID
# - QUICKBOOKS_CLIENT_SECRET: Your QuickBooks app client secret
# - QUICKBOOKS_REALM_ID: Your QuickBooks company ID (realm ID)
#
# Optional:
# - QUICKBOOKS_USE_SANDBOX: Set to 'true' to use sandbox environment

Rails.application.config.quickbooks = ActiveSupport::OrderedOptions.new
Rails.application.config.quickbooks.client_id = ENV.fetch("QUICKBOOKS_CLIENT_ID", nil)
Rails.application.config.quickbooks.client_secret = ENV.fetch("QUICKBOOKS_CLIENT_SECRET", nil)
Rails.application.config.quickbooks.use_sandbox = ENV.fetch("QUICKBOOKS_USE_SANDBOX", "false") == "true"

# OAuth endpoints
Rails.application.config.quickbooks.authorization_endpoint = "https://appcenter.intuit.com/connect/oauth2"
Rails.application.config.quickbooks.token_endpoint = "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
Rails.application.config.quickbooks.revoke_endpoint = "https://developer.api.intuit.com/v2/oauth2/tokens/revoke"

# API endpoints
Rails.application.config.quickbooks.api_url = if Rails.application.config.quickbooks.use_sandbox
  "https://sandbox-quickbooks.api.intuit.com/v3/company"
else
  "https://quickbooks.api.intuit.com/v3/company"
end

# OAuth scopes
Rails.application.config.quickbooks.scopes = [
  "com.intuit.quickbooks.accounting",
  "com.intuit.quickbooks.payment"
].join(" ")

# Redirect URI (update this for your environment)
Rails.application.config.quickbooks.redirect_uri = if Rails.env.production?
  ENV.fetch("QUICKBOOKS_REDIRECT_URI", "https://yourdomain.com/auth/quickbooks/callback")
else
  "http://localhost:3000/auth/quickbooks/callback"
end
