require 'rails_helper'

RSpec.describe "UserCodes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/user_codes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/user_codes/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/user_codes/create"
      expect(response).to have_http_status(:success)
    end
  end

end
