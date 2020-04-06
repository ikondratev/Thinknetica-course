require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe '.generate' do
    context 'with valid params' do
      let(:params) { { provider: 'github', uid: '123', email: 'test@test.test' } }

      it 'return authorization if user with the email exist' do
        create(:user, email: params[:email])
        expect(Authorization.generate(params)).to be_a Authorization
      end

      it 'return authorization if user with the email does not exist' do
        expect(Authorization.generate(params)).to be_a Authorization
      end

      it 'return existing authorization if this already exist' do
        user = create(:user, email: params[:email])
        authorization = create(:authorization, provider: params[:provider], uid: params[:uid], user: user)
        expect(Authorization.generate(params).uid).to eq authorization.uid
      end
    end

    context 'with invalid params' do
      let(:params_nil) { {} }
      let(:params_uid_nil) { { provider: 'github', email: 'test@test.test' } }
      let(:params_provider_nil) { { uid: '123', email: 'test@test.test' } }
      let(:params_email_nil) { { provider: 'github', uid: '123' } }

      it 'return nill authorization if params nill' do
        expect(Authorization.generate(params_nil)).to_not be_a Authorization
      end

      it 'return nill authorization if params[:email] nill' do
        expect(Authorization.generate(params_uid_nil)).to_not be_a Authorization
      end

      it 'return nill authorization if params[:provider] nill' do
        expect(Authorization.generate(params_provider_nil)).to_not be_a Authorization
      end

      it 'return nill authorization if params[:uid] nill' do
        expect(Authorization.generate(params_email_nil)).to_not be_a Authorization
      end
    end
  end
end
