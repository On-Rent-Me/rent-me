require 'rails_helper'

RSpec.describe QuickbooksService do
  let(:realm_id) { "123456789" }
  let(:access_token) { "test_access_token" }
  let(:service) { described_class.new(realm_id: realm_id, access_token: access_token, use_sandbox: true) }

  describe "#initialize" do
    it "sets up the service with required parameters" do
      expect(service.instance_variable_get(:@realm_id)).to eq(realm_id)
      expect(service.instance_variable_get(:@access_token)).to eq(access_token)
    end

    it "uses sandbox URL when use_sandbox is true" do
      expect(service.instance_variable_get(:@base_url)).to eq(described_class::SANDBOX_URL)
    end

    it "uses production URL when use_sandbox is false" do
      prod_service = described_class.new(realm_id: realm_id, access_token: access_token, use_sandbox: false)
      expect(prod_service.instance_variable_get(:@base_url)).to eq(described_class::BASE_URL)
    end
  end

  describe "#get_company_info" do
    it "makes a GET request to the company info endpoint" do
      stub_request(:get, "https://sandbox-quickbooks.api.intuit.com/v3/company/#{realm_id}/companyinfo/#{realm_id}?minorversion=65")
        .with(
          headers: {
            'Authorization' => "Bearer #{access_token}"
          }
        )
        .to_return(
          status: 200,
          body: { CompanyInfo: { CompanyName: "Test Company" } }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      result = service.get_company_info
      expect(result["CompanyInfo"]["CompanyName"]).to eq("Test Company")
    end
  end

  describe "error handling" do
    it "raises QuickbooksAuthenticationError on 401" do
      stub_request(:get, %r{https://sandbox-quickbooks.api.intuit.com/v3/company/.*})
        .to_return(status: 401, body: "Unauthorized")

      expect {
        service.get_company_info
      }.to raise_error(QuickbooksService::QuickbooksAuthenticationError)
    end

    it "raises QuickbooksValidationError on 400" do
      stub_request(:get, %r{https://sandbox-quickbooks.api.intuit.com/v3/company/.*})
        .to_return(status: 400, body: "Bad Request")

      expect {
        service.get_company_info
      }.to raise_error(QuickbooksService::QuickbooksValidationError)
    end

    it "raises QuickbooksRateLimitError on 429" do
      stub_request(:get, %r{https://sandbox-quickbooks.api.intuit.com/v3/company/.*})
        .to_return(status: 429, body: "Too Many Requests")

      expect {
        service.get_company_info
      }.to raise_error(QuickbooksService::QuickbooksRateLimitError)
    end
  end
end
