module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]
      reject_unauthorized_connection if token.blank?

      payload = decode_jwt(token)
      reject_unauthorized_connection unless payload

      user = User.find_by(id: payload["id"])
      reject_unauthorized_connection unless user

      user
    rescue JWT::DecodeError, JWT::ExpiredSignature
      reject_unauthorized_connection
    end

    def decode_jwt(token)
      secret = ENV.fetch("DEVISE_JWT_SECRET_KEY", Rails.application.credentials.secret_key_base)
      JWT.decode(token, secret, true, algorithms: ["HS256"]).first
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end
