require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'Github' do
    let(:auth) { OmniAuth.config.mock_auth[:github] }
    let(:user) { create(:user, email: auth.info.email) }

    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    context 'with a new facebook user' do
      before do
        get :github
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
      it 'sign in user' do
        expect(controller.current_user).to eq User.first
      end
    end

    context 'with existing facebook user' do
      before do
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid, confirmed_at: Time.zone.now)
        get :github
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
      it 'sign in user' do
        expect(controller.current_user).to eq user
      end
    end
  end
end
