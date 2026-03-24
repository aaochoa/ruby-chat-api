require 'rails_helper'

RSpec.describe "Api::V1::Messages", type: :request do
  let(:user) { create(:user) }
  let(:recipient) { create(:user) }
  let(:conversation) { create(:conversation, user: user) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/conversations/:conversation_id/messages" do
    before do
      create_list(:message, 3, conversation: conversation, sender: user)
    end

    it "lists messages for the conversation" do
      get "/api/v1/conversations/#{conversation.id}/messages", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /api/v1/conversations/:conversation_id/messages" do
    let(:valid_params) { { body: "Hello world", recipient_ids: [recipient.id] } }

    it "creates a new message" do
      expect {
        post "/api/v1/conversations/#{conversation.id}/messages", params: valid_params, headers: headers
      }.to change(Message, :count).by(1)
      .and change(MessageRecipient, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['body']).to eq("Hello world")
    end

    it "handles media attachments" do
      file = fixture_file_upload('spec/fixtures/files/sample.png', 'image/png')
      post "/api/v1/conversations/#{conversation.id}/messages", params: { media: file, recipient_ids: [recipient.id] }, headers: headers
      
      expect(response).to have_http_status(:created)
      expect(Message.last.media).to be_attached
    end
  end
end
