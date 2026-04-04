require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }

  def generate_jwt(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end

  describe "#connect" do
    context "with a valid JWT token" do
      it "successfully connects and identifies the user" do
        token = generate_jwt(user)
        connect "/cable?token=#{token}"
        expect(connection.current_user).to eq(user)
      end
    end

    context "without a token" do
      it "rejects the connection" do
        expect { connect "/cable" }.to have_rejected_connection
      end
    end

    context "with an expired token" do
      it "rejects the connection" do
        secret = ENV.fetch("DEVISE_JWT_SECRET_KEY", Rails.application.credentials.secret_key_base)
        payload = { "id" => user.id, "exp" => 1.hour.ago.to_i }
        expired_token = JWT.encode(payload, secret, "HS256")
        expect { connect "/cable?token=#{expired_token}" }.to have_rejected_connection
      end
    end

    context "with a malformed token" do
      it "rejects the connection" do
        expect { connect "/cable?token=notavalidtoken" }.to have_rejected_connection
      end
    end

    context "with a token for a non-existent user" do
      it "rejects the connection" do
        secret = ENV.fetch("DEVISE_JWT_SECRET_KEY", Rails.application.credentials.secret_key_base)
        payload = { "id" => 0, "exp" => 24.hours.from_now.to_i }
        bad_token = JWT.encode(payload, secret, "HS256")
        expect { connect "/cable?token=#{bad_token}" }.to have_rejected_connection
      end
    end
  end
end
