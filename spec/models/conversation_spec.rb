require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'relationships' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'scopes' do
    describe '.active' do
      it 'excludes soft-deleted conversations' do
        user = create(:user)
        active_conversation = create(:conversation, user: user, deleted_at: nil)
        deleted_conversation = create(:conversation, user: user, deleted_at: Time.current)

        expect(Conversation.active).to include(active_conversation)
        expect(Conversation.active).not_to include(deleted_conversation)
      end
    end
  end

  describe '#soft_delete' do
    it 'sets deleted_at and deleted_by' do
      user = create(:user)
      conversation = create(:conversation, user: user)

      conversation.soft_delete(user)
      conversation.reload

      expect(conversation.deleted_at).not_to be_nil
      expect(conversation.deleted_by).to eq(user.id)
    end
  end
end
