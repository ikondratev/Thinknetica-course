require 'rails_helper'

RSpec.describe "FindForOauthService" do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234567') }
  subject { FindForOauthService.new(auth) }

  context 'User already has authorization' do
    it 'returns user' do
      user.authorizations.create(provider: 'github', uid: '1234567')
      expect(subject.call).to eq user
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
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'create authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'return user' do
        expect(subject.call).to eq user
      end
    end

    context 'User does not exist' do
      let(:auth) do
        OmniAuth::AuthHash.new(provider: 'github',
                               uid: '1234567',
                               info: { email: 'test@test.test' })
      end

      it 'create new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'return user' do
        expect(subject.call).to be_a(User)
      end

      it 'add user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorisation for user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization wit provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
