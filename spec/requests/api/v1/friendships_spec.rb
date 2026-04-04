require 'rails_helper'

RSpec.describe "Api::V1::Friendships", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /api/v1/friendships" do
    it "returns a list of accepted friends" do
      create(:friendship, user: user, friend: other_user, status: :accepted)
      # Mirror is created by callback

      get api_v1_friendships_path, headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json.first['id']).to eq(other_user.id)
    end
  end

  describe "POST /api/v1/friendships" do
    it "sends a friend request" do
      expect {
        post api_v1_friendships_path,
             params: { friendship: { friend_id: other_user.id } },
             headers: auth_headers(user),
             as: :json
      }.to change(Friendship, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(Friendship.last.status).to eq('pending')
    end
  end

  describe "PATCH /api/v1/friendships/:id" do
    let(:friendship) { create(:friendship, user: other_user, friend: user, status: :pending) }

    it "accepts a friend request" do
      post api_v1_friendship_acceptance_path(friendship), headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)
      expect(friendship.reload.status).to eq('accepted')
      expect(Friendship.count).to eq(2) # Original + Mirror
    end

    it "returns forbidden if not the recipient" do
      third_user = create(:user)
      post api_v1_friendship_acceptance_path(friendship), headers: auth_headers(third_user), as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/friendships/:id" do
    let!(:friendship) { create(:friendship, user: user, friend: other_user, status: :accepted) }

    it "removes the friendship" do
      expect {
        delete api_v1_friendship_path(friendship), headers: auth_headers(user), as: :json
      }.to change(Friendship, :count).by(-2)

      expect(response).to have_http_status(:no_content)
    end
  end
end
