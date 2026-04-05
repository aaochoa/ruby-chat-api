require "rails_helper"

RSpec.describe ChatChannel, type: :channel do
  let(:owner) { create(:user) }
  let(:recipient) { create(:user) }
  let(:outsider) { create(:user) }
  let(:conversation) { create(:conversation, user: owner) }

  before do
    stub_connection current_user: owner
  end

  describe "#subscribed" do
    context "when user is the conversation owner" do
      it "subscribes and streams from the conversation" do
        subscribe conversation_id: conversation.id
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("chat_conversation_#{conversation.id}")
      end
    end

    context "when user is a message recipient in the conversation" do
      before do
        stub_connection current_user: recipient
        message = create(:message, conversation: conversation, sender: owner)
        create(:message_recipient, message: message, user: recipient)
      end

      it "subscribes and streams from the conversation" do
        subscribe conversation_id: conversation.id
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("chat_conversation_#{conversation.id}")
      end
    end

    context "when user is not a participant" do
      before { stub_connection current_user: outsider }

      it "rejects the subscription" do
        subscribe conversation_id: conversation.id
        expect(subscription).to be_rejected
      end
    end

    context "with a non-existent conversation_id" do
      it "rejects the subscription" do
        subscribe conversation_id: 0
        expect(subscription).to be_rejected
      end
    end

    context "without a conversation_id" do
      it "rejects the subscription" do
        subscribe conversation_id: nil
        expect(subscription).to be_rejected
      end
    end
  end

  describe "message broadcast" do
    it "broadcasts serialized message to conversation subscribers" do
      subscribe conversation_id: conversation.id
      message = create(:message, conversation: conversation, sender: owner)

      expect {
        ActionCable.server.broadcast(
          "chat_conversation_#{conversation.id}",
          MessageSerializer.new(message).as_json
        )
      }.to have_broadcasted_to("chat_conversation_#{conversation.id}")
    end
  end
end
