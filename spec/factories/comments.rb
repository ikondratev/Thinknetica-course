FactoryBot.define do
  factory :comment, class: 'Comment' do |comment|
    comment.commentable { |c| c.association(:question) }
    sequence(:body) { |n| "MyText_#{n}" }
    user
  end
end
