module ConversationScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_conversation
  end

  private
    def set_conversation
      @conversation = Current.user.conversations.active.find(params[:conversation_id] || params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Conversation not found" }, status: :not_found
    end
end
