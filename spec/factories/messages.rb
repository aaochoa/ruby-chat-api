FactoryBot.define do
  factory :message do
    body { "Sample message body" }
    association :conversation
    association :sender, factory: :user
  end
end
