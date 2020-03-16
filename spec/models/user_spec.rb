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

    context 'User already has authorization' do
      it 'returns user' do
        user.authorizations.create(provider: 'github', uid: '1234567')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'User has not authorization' do
      context 'user already exist' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'github',
                                 uid: '1234567',
                                 info: { email: user.email })
        end
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'User does not exist' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'github',
                                 uid: '1234567',
                                 info: { email: 'test@test.test' })
        end

        it 'create new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'add user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorisation for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization wit provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
