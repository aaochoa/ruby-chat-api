require "rails_helper"

RSpec.describe AppearanceChannel, type: :channel do
  let(:owner) { create(:user) }
  let(:recipient) { create(:user) }
  let(:outsider) { create(:user) }
  let(:conversation) { create(:conversation, user: owner) }

  before { stub_connection current_user: owner }

  describe "#subscribed" do
    context "when user is the conversation owner" do
      it "confirms subscription and streams from the conversation" do
        subscribe conversation_id: conversation.id
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("appearance_conversation_#{conversation.id}")
      end
    end

    context "when user is a message recipient" do
      before do
        stub_connection current_user: recipient
        message = create(:message, conversation: conversation, sender: owner)
        create(:message_recipient, message: message, user: recipient)
      end

      it "confirms subscription" do
        subscribe conversation_id: conversation.id
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("appearance_conversation_#{conversation.id}")
      end
    end

    context "when user is not a participant" do
      before { stub_connection current_user: outsider }

      it "rejects the subscription" do
        subscribe conversation_id: conversation.id
        expect(subscription).to be_rejected
      end
    end
  end

  describe "#typing" do
    before { subscribe conversation_id: conversation.id }

    context "when typing: true" do
      it "broadcasts typing status with user info to the conversation stream" do
        expect {
          perform :typing, { "typing" => true }
        }.to have_broadcasted_to("appearance_conversation_#{conversation.id}").with(
          hash_including(
            user_id: owner.id,
            typing: true
          )
        )
      end
    end

    context "when typing: false" do
      it "broadcasts stopped-typing status to the conversation stream" do
        expect {
          perform :typing, { "typing" => false }
        }.to have_broadcasted_to("appearance_conversation_#{conversation.id}").with(
          hash_including(
            user_id: owner.id,
            typing: false
          )
        )
      end
    end
  end
end
