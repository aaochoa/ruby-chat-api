require "rails_helper"

RSpec.describe PresenceChannel, type: :channel do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:stranger) { create(:user) }

  before do
    # Clear online users between tests
    PresenceChannel::ONLINE_USERS.clear
    stub_connection current_user: user
  end

  describe "#subscribed" do
    context "when a user subscribes" do
      it "streams from their personal presence stream" do
        subscribe
        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("presence_user_#{user.id}")
      end

      it "marks the user as online" do
        subscribe
        expect(PresenceChannel::ONLINE_USERS).to include(user.id)
      end

      it "broadcasts online status to accepted friends" do
        create(:friendship, user: user, friend: friend, status: :accepted)

        expect {
          subscribe
        }.to have_broadcasted_to("presence_user_#{friend.id}").with(
          user_id: user.id, status: "online"
        )
      end

      it "does not broadcast to strangers" do
        expect {
          subscribe
        }.not_to have_broadcasted_to("presence_user_#{stranger.id}")
      end

      it "sends the list of currently online friends upon subscription" do
        create(:friendship, user: user, friend: friend, status: :accepted)
        PresenceChannel::ONLINE_USERS.add(friend.id)

        subscribe

        expect(transmissions.last).to include("online_friends" => [friend.id])
      end

      it "sends an empty online friends list when no friends are online" do
        subscribe
        expect(transmissions.last).to include("online_friends" => [])
      end
    end
  end

  describe "#unsubscribed" do
    before do
      create(:friendship, user: user, friend: friend, status: :accepted)
      subscribe
    end

    it "removes the user from the online set" do
      unsubscribe
      expect(PresenceChannel::ONLINE_USERS).not_to include(user.id)
    end

    it "broadcasts offline status to accepted friends" do
      expect {
        unsubscribe
      }.to have_broadcasted_to("presence_user_#{friend.id}").with(
        user_id: user.id, status: "offline"
      )
    end
  end
end
