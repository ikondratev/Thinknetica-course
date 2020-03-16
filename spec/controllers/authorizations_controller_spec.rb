require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  let(:valid_params) { { provider: 'github', uid: '123123', email: 'test@test.ru' } }

  before do
    session[:auth] = { 'uid' => '123123', 'provider' => 'github' }
  end

  describe 'POST #create' do
    it 'saves the new Authorization in the database' do
      expect { post :create, params: valid_params }.to change(Authorization, :count).by(1)
    end
    it 'redirect to root' do
      post :create, params: valid_params
      expect(response).to redirect_to root_path
    end
  end
end
