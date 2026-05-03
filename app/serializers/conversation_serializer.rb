class ConversationSerializer
  def initialize(conversation)
    @conversation = conversation
  end

  def as_json(*)
    data = {
      id: @conversation.id,
      name: @conversation.title,
      userId: @conversation.user_id,
      createdAt: @conversation.created_at,
      updatedAt: @conversation.updated_at,
      otherParticipants: other_participants,
      lastMessage: last_message
    }
    data[:messages] = @conversation.messages.collect { |m| MessageSerializer.new(m).as_json } if @include_messages
    data
  end

  def with_messages
    @include_messages = true
    self
  end

  private

  def last_message
    msg = @conversation.messages.order(created_at: :desc).first
    MessageSerializer.new(msg).as_json if msg
  end

  def other_participants
    # In this simple model, participants are the creator and recipients of messages
    participant_ids = @conversation.messages.joins(:message_recipients).pluck("message_recipients.user_id").uniq
    # Exclude the conversation creator? Or rather handle it by session in frontend?
    # For now, let's just return all users who are not the creator
    User.where(id: participant_ids).where.not(id: @conversation.user_id).collect { |u| UserSerializer.new(u).as_json }
  end
end
