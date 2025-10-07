require 'intuit-oauth'

class QuickbooksTestController < ApplicationController
  def index
    # Display the test page with connect button
  end

  def connect
    oauth_client = create_oauth_client

    scopes = [
      IntuitOAuth::Scopes::ACCOUNTING
    ]

    authorization_url = oauth_client.code.get_auth_uri(scopes)
    redirect_to authorization_url, allow_other_host: true
  end

  def callback
    # Exchange authorization code for access token
    oauth_client = create_oauth_client

    if params[:code].present?
      begin
        result = oauth_client.token.get_bearer_token(params[:code])

        # Store tokens in session (in production, store in database)
        session[:qb_access_token] = result.access_token
        session[:qb_refresh_token] = result.refresh_token
        session[:qb_realm_id] = params[:realmId]

        # Test the connection by making a direct API call
        base_url = ENV['QUICKBOOKS_USE_SANDBOX'] == 'true' ?
          'https://sandbox-quickbooks.api.intuit.com' :
          'https://quickbooks.api.intuit.com'

        uri = URI("#{base_url}/v3/company/#{params[:realmId]}/companyinfo/#{params[:realmId]}?minorversion=65")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "Bearer #{result.access_token}"
        request['Accept'] = 'application/json'
        request['Content-Type'] = 'application/json'

        response = http.request(request)

        if response.is_a?(Net::HTTPSuccess)
          @company_info = JSON.parse(response.body)
          @success = true
        else
          @error = "API Error: #{response.code} - #{response.body}"
          @success = false
        end

      rescue StandardError => e
        @error = "#{e.class}: #{e.message}"
        @success = false
      end
    else
      @error = params[:error] || "No authorization code received"
      @success = false
    end
  end

  def test_api
    # Test API call with stored token
    if session[:qb_access_token].blank? || session[:qb_realm_id].blank?
      @error = "Please connect to QuickBooks first"
      render turbo_stream: turbo_stream.replace("api_results", partial: "quickbooks_test/api_error")
      return
    end

    begin
      # Make direct API calls using Net::HTTP
      base_url = ENV['QUICKBOOKS_USE_SANDBOX'] == 'true' ?
        'https://sandbox-quickbooks.api.intuit.com' :
        'https://quickbooks.api.intuit.com'

      # Get company info
      company_uri = URI("#{base_url}/v3/company/#{session[:qb_realm_id]}/companyinfo/#{session[:qb_realm_id]}?minorversion=65")
      @company_info = make_api_request(company_uri, session[:qb_access_token])

      # Get customers
      query = CGI.escape("SELECT * FROM Customer")
      customers_uri = URI("#{base_url}/v3/company/#{session[:qb_realm_id]}/query?query=#{query}&minorversion=65")
      @customers = make_api_request(customers_uri, session[:qb_access_token])

      render turbo_stream: turbo_stream.replace("api_results", partial: "quickbooks_test/api_success")
    rescue StandardError => e
      @error = "#{e.class}: #{e.message}"
      render turbo_stream: turbo_stream.replace("api_results", partial: "quickbooks_test/api_error")
    end
  end

  def disconnect
    session.delete(:qb_access_token)
    session.delete(:qb_refresh_token)
    session.delete(:qb_realm_id)
    redirect_to quickbooks_test_index_path, notice: "Disconnected from QuickBooks"
  end

  private

  def create_oauth_client
    IntuitOAuth::Client.new(
      ENV['QUICKBOOKS_CLIENT_ID'],
      ENV['QUICKBOOKS_CLIENT_SECRET'],
      'http://localhost:3000/quickbooks_test/callback',
      ENV['QUICKBOOKS_USE_SANDBOX'] == 'true' ? 'sandbox' : 'production'
    )
  end

  def make_api_request(uri, access_token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{access_token}"
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      raise "API Error: #{response.code} - #{response.body}"
    end
  end
end
