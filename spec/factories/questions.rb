FactoryBot.define do
  sequence :title do |t|
    "New question title n #{t}"
  end

  factory :question do
    user
    title
    body { 'MyText' }

    trait :invalid do
      body { nil }
    end

    trait :with_answer do
      after(:create) do |q|
        create_list(:answer, 7, question: q)
      end
    end
  end
end
