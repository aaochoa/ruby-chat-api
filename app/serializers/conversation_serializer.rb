class ConversationSerializer
  def initialize(conversation)
    @conversation = conversation
  end

  def as_json(*)
    {
      id: @conversation.id,
      title: @conversation.title,
      user_id: @conversation.user_id,
      created_at: @conversation.created_at,
      updated_at: @conversation.updated_at
    }
  end
end
