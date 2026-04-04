module Api
  module V1
    class AuthController < ApplicationController
      wrap_parameters false
      before_action :authenticate_user!, only: [ :profile ]

      def register
        user = User.new(user_params)
        if user.save
          token = generate_token(user)
          render json: AuthResponseSerializer.new(user, token).as_json, status: :created
        elsif user.errors[:email].include?("has already been taken")
          render json: { errors: user.errors.full_messages }, status: :conflict
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          token = generate_token(user)
          render json: AuthResponseSerializer.new(user, token).as_json, status: :ok
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def profile
        render json: UserSerializer.new(current_user).as_json, status: :ok
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def generate_token(user)
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end
    end
  end
end
