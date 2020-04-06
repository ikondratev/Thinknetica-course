require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  let(:params) { { email: ['test@test.test'], auth: { provider: 'github', uid: '123' } } }

  describe 'POST#create' do
    before { post :create, params: params }

    it 'sending email with content' do
      expect(current_email).to have_content 'Confirm account'
    end
  end
end
