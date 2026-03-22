require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  let(:valid_attributes) { attributes_for(:user) }
  let(:user) { create(:user) }

  describe "POST /api/v1/auth/register" do
    context "with valid parameters" do
      it "creates a new user and returns a token" do
        expect {
          post api_v1_auth_register_path, params: valid_attributes, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity" do
        post api_v1_auth_register_path, params: { email: 'invalid' }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns conflict when email exists" do
        create(:user, email: 'test@example.com')
        post api_v1_auth_register_path, params: { email: 'test@example.com', password: 'password123' }, as: :json
        expect(response).to have_http_status(:conflict)
      end
    end
  end

  describe "POST /api/v1/auth/login" do
    it "logins successfully with valid credentials" do
      post api_v1_auth_login_path, params: { email: user.email, password: user.password }, as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it "returns unauthorized with invalid credentials" do
      post api_v1_auth_login_path, params: { email: user.email, password: 'wrong' }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/auth/profile" do
    it "returns profile when authorized" do
      get api_v1_auth_profile_path, headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['email']).to eq(user.email)
    end

    it "returns unauthorized when missing token" do
      get api_v1_auth_profile_path, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
