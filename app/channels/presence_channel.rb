class PresenceChannel < ApplicationCable::Channel
  # Thread-safe tracking of online user IDs for single-server presence.
  # For multi-server deployments, replace with a Redis-backed store.
  ONLINE_USERS = Concurrent::Set.new

  def subscribed
    stream_from "presence_user_#{current_user.id}"

    ONLINE_USERS.add(current_user.id)

    broadcast_status_to_friends("online")
    transmit_online_friends
  end

  def unsubscribed
    ONLINE_USERS.delete(current_user.id)
    broadcast_status_to_friends("offline")
    stop_all_streams
  end

  private

  def broadcast_status_to_friends(status)
    current_user.friends.each do |friend|
      ActionCable.server.broadcast(
        "presence_user_#{friend.id}",
        { user_id: current_user.id, status: status }
      )
    end
  end

  def transmit_online_friends
    online_friend_ids = current_user.friends.pluck(:id) & ONLINE_USERS.to_a
    transmit({ online_friends: online_friend_ids })
  end
end
