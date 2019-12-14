FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678910' }
    password_confirmation { '12345678910' }
  end
end
