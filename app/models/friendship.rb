class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: :friend_id }
  validate :cannot_friend_self

  after_create :create_inverse, if: :accepted?
  after_update :create_inverse, if: -> { accepted? && saved_change_to_status? }
  after_destroy :destroy_inverse, if: :accepted?

  private

  def cannot_friend_self
    errors.add(:friend_id, "cannot be yourself") if user_id == friend_id
  end

  def create_inverse
    Friendship.create_with(status: :accepted).find_or_create_by!(user_id: friend_id, friend_id: user_id)
  end

  def destroy_inverse
    inverse = Friendship.find_by(user_id: friend_id, friend_id: user_id)
    inverse&.destroy
  end
end
