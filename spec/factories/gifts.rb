include ActionDispatch::TestProcess
FactoryBot.define do
  factory :gift do
    sequence(:name) { |n| "Gift_#{n}" }
    image { fixture_file_upload(Rails.root.join('spec', 'images', 'gift.jpg'), 'image/jpeg') }
  end
end
