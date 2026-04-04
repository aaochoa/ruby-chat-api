class ApplicationController < ActionController::API
  rescue_from JWT::DecodeError, with: :handle_jwt_invalid
  rescue_from JWT::ExpiredSignature, with: :handle_jwt_expired

  private

  def authenticate_user!
    token = extract_token_from_header
    return handle_jwt_missing unless token

    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      Current.user = User.find_by(id: payload["sub"] || payload["id"])
      handle_jwt_invalid unless Current.user
    rescue JWT::ExpiredSignature => e
      handle_jwt_expired(e)
    rescue JWT::DecodeError => e
      handle_jwt_invalid(e)
    end
  end

  def current_user
    Current.user
  end

  def extract_token_from_header
    request.headers["Authorization"]&.split("Bearer ")&.last
  end

  def handle_jwt_invalid(e = nil)
    render json: { error: "Invalid JWT" }, status: :unauthorized
  end

  def handle_jwt_expired(e = nil)
    render json: { error: "Expired JWT" }, status: :unauthorized
  end

  def handle_jwt_missing
    render json: { error: "Missing JWT" }, status: :unauthorized
  end
end
