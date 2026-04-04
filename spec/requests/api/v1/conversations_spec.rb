require 'rails_helper'

RSpec.describe "Api::V1::Conversations", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_attributes) { { conversation: { title: "New Conversation" } } }
  let(:invalid_attributes) { { conversation: { title: "" } } }

  describe "GET /api/v1/conversations" do
    it "returns active conversations for the current user" do
      create(:conversation, user: user, title: "Mine")
      create(:conversation, user: user, title: "Deleted", deleted_at: Time.current)
      create(:conversation, user: other_user, title: "Others")

      get api_v1_conversations_path, headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json.first['title']).to eq("Mine")
    end

    it "returns unauthorized when missing token" do
      get api_v1_conversations_path, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /api/v1/conversations" do
    context "with valid parameters" do
      it "creates a new conversation for the current user" do
        expect {
          post api_v1_conversations_path, params: valid_attributes, headers: auth_headers(user), as: :json
        }.to change(Conversation, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['user_id']).to eq(user.id)
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity" do
        post api_v1_conversations_path, params: invalid_attributes, headers: auth_headers(user), as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /api/v1/conversations/:id" do
    let(:conversation) { create(:conversation, user: user) }

    it "returns the conversation" do
      get api_v1_conversation_path(conversation), headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(conversation.id)
    end

    it "returns not found for other users conversation" do
      other_conversation = create(:conversation, user: other_user)
      get api_v1_conversation_path(other_conversation), headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:not_found)
    end

    it "returns not found for soft-deleted conversation" do
      conversation.soft_delete(user)
      get api_v1_conversation_path(conversation), headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/v1/conversations/:id" do
    let(:conversation) { create(:conversation, user: user, title: "Old") }

    it "updates the conversation" do
      patch api_v1_conversation_path(conversation), params: { conversation: { title: "New" } }, headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)
      expect(conversation.reload.title).to eq("New")
    end

    it "returns unprocessable entity with invalid params" do
      patch api_v1_conversation_path(conversation), params: invalid_attributes, headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v1/conversations/:id" do
    let(:conversation) { create(:conversation, user: user) }

    it "soft-deletes the conversation" do
      delete api_v1_conversation_path(conversation), headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:ok)

      conversation.reload
      expect(conversation.deleted_at).not_to be_nil
      expect(conversation.deleted_by).to eq(user.id)
    end

    it "cannot delete others conversation" do
      other_conversation = create(:conversation, user: other_user)
      delete api_v1_conversation_path(other_conversation), headers: auth_headers(user), as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
