module Api
  module V1
    class FriendshipsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_friendship, only: [:update, :destroy]

      def index
        friends = current_user.friends
        render json: friends.collect { |f| UserSerializer.new(f).as_json }, status: :ok
      end

      def create
        friendship = current_user.friendships.new(friendship_params)
        friendship.status = :pending
        
        if friendship.save
          render json: { message: 'Friend request sent', friendship: friendship }, status: :created
        else
          render json: { errors: friendship.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @friendship.friend_id == current_user.id && @friendship.pending?
          if @friendship.accepted!
            render json: { message: 'Friend request accepted' }, status: :ok
          else
            render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Invalid operation' }, status: :forbidden
        end
      end

      def destroy
        if @friendship.user_id == current_user.id || @friendship.friend_id == current_user.id
          @friendship.destroy
          head :no_content
        else
          render json: { error: 'Not authorized' }, status: :unauthorized
        end
      end

      private

      def set_friendship
        @friendship = Friendship.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Friendship not found' }, status: :not_found
      end

      def friendship_params
        params.require(:friendship).permit(:friend_id)
      end
    end
  end
end
