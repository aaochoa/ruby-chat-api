require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }

    it 'validates uniqueness of email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'validates format of email' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it { is_expected.to validate_length_of(:first_name).is_at_most(50) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(50) }

    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe '.searchable_by' do
    let!(:user_a) { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@example.com') }
    let!(:user_b) { create(:user, first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com') }
    let!(:user_c) { create(:user, first_name: 'Bob', last_name: 'John', email: 'bob@example.com') }
    let(:me) { create(:user) }

    it 'finds users by first name' do
      results = User.searchable_by('John', me.id)
      expect(results).to include(user_a)
      expect(results).to include(user_c)
      expect(results).not_to include(user_b)
    end

    it 'finds users by last name' do
      results = User.searchable_by('Doe', me.id)
      expect(results).to contain_exactly(user_a)
    end

    it 'finds users by email' do
      results = User.searchable_by('jane@example.com', me.id)
      expect(results).to contain_exactly(user_b)
    end

    it 'excludes current user' do
      results = User.searchable_by(me.email, me.id)
      expect(results).to be_empty
    end

    it 'excludes specific IDs (friends)' do
      results = User.searchable_by('John', me.id, [ user_a.id ])
      expect(results).to contain_exactly(user_c)
    end
  end
end
