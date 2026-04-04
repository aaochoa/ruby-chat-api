module Api
  module V1
    class MessagesController < ApplicationController
      include ConversationScoped

      before_action :authenticate_user!
      before_action :set_message, only: [ :show ]

      def index
        messages = @conversation.messages.includes(:sender, :receivers).order(created_at: :asc)
        render json: messages.collect { |m| MessageSerializer.new(m).as_json }, status: :ok
      end

      def show
        render json: MessageSerializer.new(@message).as_json, status: :ok
      end

      def create
        message = @conversation.messages.new(message_params.merge(sender: current_user))
        message.receiver_ids = params[:recipient_ids]

        if message.save
          render json: MessageSerializer.new(message).as_json, status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_message
        @message = @conversation.messages.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Message not found" }, status: :not_found
      end

      def message_params
        params.permit(:body, :media)
      end
    end
  end
end
