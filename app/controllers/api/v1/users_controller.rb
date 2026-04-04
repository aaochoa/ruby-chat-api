module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def search
        query = params[:query]
        if query.blank?
          return render json: { users: [] }, status: :ok
        end

        # Gather all friend IDs of the current user to exclude from results
        friend_ids = current_user.friends.pluck(:id)
        users = User.searchable_by(query, current_user.id, friend_ids)

        render json: users.collect { |u| UserSerializer.new(u).as_json }, status: :ok
      end

      def update_profile
        if current_user.update(user_params)
          render json: UserSerializer.new(current_user).as_json, status: :ok
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name)
      end
    end
  end
end
