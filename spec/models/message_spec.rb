require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:conversation) }
  it { should belong_to(:sender).class_name('User') }
  it { should have_many(:message_recipients).dependent(:destroy) }
  it { should have_many(:receivers).through(:message_recipients).source(:user) }

  it { should validate_presence_of(:body) }

  context "when media is attached" do
    let(:message) { build(:message, body: nil) }

    before do
      message.media.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample.png')), filename: 'sample.png', content_type: 'image/png')
      message.save
    end

    it "is valid without a body" do
      expect(message).to be_valid
    end
  end
end
