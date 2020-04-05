require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { OmniAuth.config.mock_auth[:github] }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'resirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user is not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirect to index page' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Facebook' do
    let(:oauth_data) { OmniAuth.config.mock_auth[:facebook] }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :facebook
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :facebook
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'resirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user is not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :facebook
      end

      it 'redirect to index page' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Twitter' do
    let(:oauth_data) { OmniAuth.config.mock_auth[:twitter] }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :twitter
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :twitter
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'resirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user is not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :twitter
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
