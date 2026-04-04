require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user, first_name: 'OriginalFirst', last_name: 'OriginalLast') }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/users/search" do
    let!(:friend) { create(:user, first_name: 'FriendUser') }
    let!(:other) { create(:user, first_name: 'OtherUser') }
    let!(:friendship) { create(:friendship, user: user, friend: friend, status: :accepted) }

    it "requires authentication" do
      get "/api/v1/users/search", params: { query: 'User' }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns matching users excluding friends and self" do
      get api_v1_users_search_path(query: 'User'), headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      emails = json.map { |u| u['email'] }
      expect(emails).to include(other.email)
      expect(emails).not_to include(friend.email)
      expect(emails).not_to include(user.email)
    end

    it "returns empty array for empty query" do
      get api_v1_users_search_path(query: ''), headers: headers, as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['users']).to eq([])
    end
  end

  describe "PATCH /api/v1/users/profile" do
    it "updates the user profile" do
      patch api_v1_users_profile_path, params: { user: { first_name: 'NewFirst', last_name: 'NewLast' } }, headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.first_name).to eq('NewFirst')
      expect(user.last_name).to eq('NewLast')
    end
  end
end
