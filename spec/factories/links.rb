FactoryBot.define do
  factory :link, class: 'Link' do |link|
    link.linkable { |c| c.association(:question) }
    sequence(:name) { |_n| "My link" }
    sequence(:url) { |_n| "https://example.com" }
  end
end
