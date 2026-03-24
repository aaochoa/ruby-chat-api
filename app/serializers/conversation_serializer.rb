class ConversationSerializer
  def initialize(conversation)
    @conversation = conversation
  end

  def as_json(*)
    data = {
      id: @conversation.id,
      title: @conversation.title,
      user_id: @conversation.user_id,
      created_at: @conversation.created_at,
      updated_at: @conversation.updated_at
    }
    data[:messages] = @conversation.messages.collect { |m| MessageSerializer.new(m).as_json } if @include_messages
    data
  end

  def with_messages
    @include_messages = true
    self
  end
end
