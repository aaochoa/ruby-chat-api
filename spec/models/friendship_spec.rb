require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    it 'is valid with valid attributes' do
      friendship = build(:friendship, user: user, friend: friend)
      expect(friendship).to be_valid
    end

    it 'prevents duplicate friendships' do
      create(:friendship, user: user, friend: friend)
      duplicate = build(:friendship, user: user, friend: friend)
      expect(duplicate).not_to be_valid
    end

    it 'prevents self-friendship' do
      self_friendship = build(:friendship, user: user, friend: user)
      expect(self_friendship).not_to be_valid
      expect(self_friendship.errors[:friend_id]).to include('cannot be yourself')
    end
  end

  describe 'callbacks' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    it 'creates a mirror friendship when status changes to accepted' do
      friendship = create(:friendship, user: user, friend: friend, status: :pending)

      expect {
        friendship.accepted!
      }.to change(Friendship, :count).by(1)

      mirror = Friendship.find_by(user_id: friend.id, friend_id: user.id)
      expect(mirror).not_to be_nil
      expect(mirror.status).to eq('accepted')
    end

    it 'destroys the mirror friendship when deleted' do
      friendship = create(:friendship, user: user, friend: friend, status: :accepted)
      # Creating the second record manually or via callback above
      # Actually, the callback would have created it if we used .accepted!
      # Let's reload to be sure.

      expect(Friendship.count).to eq(2)

      expect {
        friendship.destroy
      }.to change(Friendship, :count).by(-2)
    end
  end
end
