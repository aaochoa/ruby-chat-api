module Api
  module V1
    class ConversationsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_conversation, only: [:show, :update, :destroy]

      def index
        conversations = current_user.conversations.active
        serializer = conversations.collect do |c|
          s = ConversationSerializer.new(c)
          s.with_messages if params[:include_messages] == 'true'
          s.as_json
        end
        render json: serializer, status: :ok
      end

      def show
        serializer = ConversationSerializer.new(@conversation)
        serializer.with_messages if params[:include_messages] == 'true'
        render json: serializer.as_json, status: :ok
      end

      def create
        cp = conversation_params
        cp[:title] = "New Conversation #{current_user.conversations.count + 1}" if cp[:title].blank?
        conversation = current_user.conversations.new(cp)

        if conversation.save
          render json: ConversationSerializer.new(conversation).as_json, status: :created
        else
          render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @conversation.update(conversation_params)
          render json: ConversationSerializer.new(@conversation).as_json, status: :ok
        else
          render json: { errors: @conversation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @conversation.soft_delete(current_user)
          render json: { message: 'Conversation soft-deleted' }, status: :ok
        else
          render json: { errors: 'Unable to delete conversation' }, status: :unprocessable_entity
        end
      end

      private

      def set_conversation
        @conversation = current_user.conversations.active.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Conversation not found' }, status: :not_found
      end

      def conversation_params
        params.require(:conversation).permit(:title)
      end
    end
  end
end
