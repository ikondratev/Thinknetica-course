require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:gifts) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:question) { create(:question) }
  let(:user) { question.user }
  let(:other_question) { create(:question) }

  it 'determines the author of the question' do
    expect(user).to be_is_author_of(question)
  end

  it 'determines that user is not author of the question' do
    expect(user).not_to be_is_author_of(other_question)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234567') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '.create_by_email' do
    let(:params) { { provider: 'github', uid: '123', email: 'test@test.test' } }

    it 'Create and get new user' do
      expect(User.create_by_email(params)).to be_a User
    end

    it 'Do not create and return User if user exist' do
      create(:user, email: 'test@test.test')
      expect(User.create_by_email(params)).to be_a User
    end
  end
end
