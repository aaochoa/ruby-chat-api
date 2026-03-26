module Api
  module V1
    class Friendships::AcceptancesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_friendship

      def create
        if @friendship.friend_id == current_user.id && @friendship.pending?
          if @friendship.accept!
            render json: { message: 'Friend request accepted' }, status: :ok
          else
            render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Invalid operation' }, status: :forbidden
        end
      end

      private

      def set_friendship
        @friendship = Friendship.find(params[:friendship_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Friendship not found' }, status: :not_found
      end
    end
  end
end
