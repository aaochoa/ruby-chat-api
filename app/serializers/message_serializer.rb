class MessageSerializer
  def initialize(message)
    @message = message
  end

  def as_json
    {
      id: @message.id,
      content: @message.body,
      conversationId: @message.conversation_id,
      senderId: @message.sender_id,
      sender: UserSerializer.new(@message.sender).as_json,
      receivers: @message.receivers.collect { |u| UserSerializer.new(u).as_json },
      mediaUrl: media_url,
      createdAt: @message.created_at,
      updatedAt: @message.updated_at
    }
  end

  private

  def media_url
    return nil unless @message.media.attached?

    begin
      @message.media.url
    rescue ArgumentError
      # Context for testing or without full URL options
      "/rails/active_storage/blobs/redirect/#{@message.media.blob.signed_id}/#{@message.media.blob.filename}"
    end
  end
end
