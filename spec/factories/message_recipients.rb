FactoryBot.define do
  factory :message_recipient do
    association :message
    association :user
  end
end
