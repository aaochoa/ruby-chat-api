class Friendship < ApplicationRecord
  include Inverse

  belongs_to :user
  belongs_to :friend, class_name: "User"

  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: :friend_id }
  validate :cannot_friend_self

  def accept!
    accepted!
  end

  private

  def cannot_friend_self
    errors.add(:friend_id, "cannot be yourself") if user_id == friend_id
  end
end
