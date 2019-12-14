require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:answers) }
  it { should have_many(:questions) }

  let(:question) { create(:question) }
  let(:user) { question.user }
  let(:other_question) { create(:question) }

  it 'determines the author of the question' do
    expect(user).to be_is_author_of(question)
  end

  it 'determines that user is not author of the question' do
    expect(user).not_to be_is_author_of(other_question)
  end
end
