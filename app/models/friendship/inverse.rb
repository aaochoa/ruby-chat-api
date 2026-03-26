module Friendship::Inverse
  extend ActiveSupport::Concern

  included do
    after_create :create_inverse, if: :accepted?
    after_update :create_inverse, if: -> { accepted? && saved_change_to_status? }
    after_destroy :destroy_inverse, if: :accepted?
  end

  private

  def create_inverse
    Friendship.create_with(status: :accepted).find_or_create_by!(user_id: friend_id, friend_id: user_id)
  end

  def destroy_inverse
    inverse = Friendship.find_by(user_id: friend_id, friend_id: user_id)
    inverse&.destroy
  end
end
