require 'rails_helper'

RSpec.describe "QuickbooksTests", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/quickbooks_test/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /callback" do
    it "returns http success" do
      get "/quickbooks_test/callback"
      expect(response).to have_http_status(:success)
    end
  end

end
