class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtRevocationStrategy

  has_many :conversations, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def jwt_payload
    {
      id: id,
      email: email
    }
  end
end
