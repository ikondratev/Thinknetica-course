FactoryBot.define do
  sequence :title do |t|
    "New question title n #{t}"
  end

  factory :question do
    user
    title
    body { 'MyText' }

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :with_answer do
      after(:create) do |q|
        create_list(:answer, 1, question: q)
      end
    end
  end
end
