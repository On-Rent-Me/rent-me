class QuickbooksService
  BASE_URL = "https://quickbooks.api.intuit.com/v3/company"
  SANDBOX_URL = "https://sandbox-quickbooks.api.intuit.com/v3/company"

  def initialize(realm_id:, access_token:, use_sandbox: false)
    @realm_id = realm_id
    @access_token = access_token
    @base_url = use_sandbox ? SANDBOX_URL : BASE_URL
  end

  # Query endpoint - general purpose query
  def query(query_string)
    endpoint = "#{@base_url}/#{@realm_id}/query?query=#{CGI.escape(query_string)}&minorversion=65"

    response = connection.get(endpoint)
    handle_response(response)
  end

  # Customer operations
  def get_customers
    query("SELECT * FROM Customer")
  end

  def get_customer(id)
    endpoint = "#{@base_url}/#{@realm_id}/customer/#{id}?minorversion=65"

    response = connection.get(endpoint)
    handle_response(response)
  end

  def create_customer(customer_data)
    endpoint = "#{@base_url}/#{@realm_id}/customer?minorversion=65"

    response = connection.post(endpoint) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = customer_data.to_json
    end
    handle_response(response)
  end

  # Invoice operations
  def get_invoices
    query("SELECT * FROM Invoice")
  end

  def get_invoice(id)
    endpoint = "#{@base_url}/#{@realm_id}/invoice/#{id}?minorversion=65"

    response = connection.get(endpoint)
    handle_response(response)
  end

  def create_invoice(invoice_data)
    endpoint = "#{@base_url}/#{@realm_id}/invoice?minorversion=65"

    response = connection.post(endpoint) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = invoice_data.to_json
    end
    handle_response(response)
  end

  # Payment operations
  def get_payments
    query("SELECT * FROM Payment")
  end

  def create_payment(payment_data)
    endpoint = "#{@base_url}/#{@realm_id}/payment?minorversion=65"

    response = connection.post(endpoint) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = payment_data.to_json
    end
    handle_response(response)
  end

  # Item operations
  def get_items
    query("SELECT * FROM Item")
  end

  def get_item(id)
    endpoint = "#{@base_url}/#{@realm_id}/item/#{id}?minorversion=65"

    response = connection.get(endpoint)
    handle_response(response)
  end

  # Company info
  def get_company_info
    endpoint = "#{@base_url}/#{@realm_id}/companyinfo/#{@realm_id}?minorversion=65"

    response = connection.get(endpoint)
    handle_response(response)
  rescue OAuth2::Error => e
    handle_oauth_error(e)
  end

  private

  def connection
    @connection ||= OAuth2::AccessToken.new(
      oauth_client,
      @access_token,
      headers: {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
    ) do |conn|
      conn.response :raise_error
    end
  end

  def oauth_client
    @oauth_client ||= OAuth2::Client.new(
      ENV["QUICKBOOKS_CLIENT_ID"],
      ENV["QUICKBOOKS_CLIENT_SECRET"],
      site: "https://appcenter.intuit.com",
      authorize_url: "/connect/oauth2",
      token_url: "/oauth2/v1/tokens/bearer"
    )
  end

  def handle_response(response)
    case response.status
    when 200..299
      JSON.parse(response.body)
    when 401
      raise QuickbooksAuthenticationError, "Authentication failed: #{response.body}"
    when 400
      raise QuickbooksValidationError, "Validation error: #{response.body}"
    when 429
      raise QuickbooksRateLimitError, "Rate limit exceeded: #{response.body}"
    else
      raise QuickbooksApiError, "API error (#{response.status}): #{response.body}"
    end
  end

  def handle_oauth_error(error)
    case error.response.status
    when 401
      raise QuickbooksAuthenticationError, "Authentication failed: #{error.response.body}"
    when 400
      raise QuickbooksValidationError, "Validation error: #{error.response.body}"
    when 429
      raise QuickbooksRateLimitError, "Rate limit exceeded: #{error.response.body}"
    else
      raise QuickbooksApiError, "API error (#{error.response.status}): #{error.response.body}"
    end
  end

  # Custom error classes
  class QuickbooksApiError < StandardError; end
  class QuickbooksAuthenticationError < QuickbooksApiError; end
  class QuickbooksValidationError < QuickbooksApiError; end
  class QuickbooksRateLimitError < QuickbooksApiError; end
end
