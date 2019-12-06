FactoryBot.define do
  sequence(:body) do |b|
    "Create test body n_#{b}"
  end
  factory :answer do
    user
    question
    body

    trait :invalid do
      body { nil }
    end
  end
end
