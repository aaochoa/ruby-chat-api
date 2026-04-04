class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    conversation = find_conversation(params[:conversation_id])

    if conversation
      stream_from "appearance_conversation_#{conversation.id}"
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def typing(data)
    ActionCable.server.broadcast(
      "appearance_conversation_#{params[:conversation_id]}",
      {
        user_id: current_user.id,
        username: current_user.email,
        typing: data["typing"]
      }
    )
  end

  private

  def find_conversation(conversation_id)
    return nil if conversation_id.blank?

    conversation = Conversation.active.find_by(id: conversation_id)
    return nil unless conversation

    participant?(conversation) ? conversation : nil
  end

  def participant?(conversation)
    return true if conversation.user_id == current_user.id

    conversation.messages
                .joins(:message_recipients)
                .where(message_recipients: { user_id: current_user.id })
                .exists?
  end
end
