FactoryBot.define do
  factory :conversation do
    association :user
    title { Faker::Lorem.sentence(word_count: 3) }
    deleted_at { nil }
    deleted_by { nil }
  end
end
