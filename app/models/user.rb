class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtRevocationStrategy

  has_many :conversations, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }

  scope :searchable_by, ->(query, current_user_id, exclude_ids = []) {
    q = "%#{query}%"
    where("(first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q) AND id != :my_id",
          q: q, my_id: current_user_id)
    .where.not(id: exclude_ids)
  }

  def jwt_payload
    {
      id: id,
      email: email
    }
  end
end
