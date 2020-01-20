require 'rails_helper'

RSpec.describe GiftsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:gifts) { create_list(:gift, 3, question: question, user: user) }

  describe 'GET #index' do
    before do
      login user
      get :index
    end

    it 'assigns gifts' do
      expect(assigns(:gifts)).to match_array(gifts)
    end

    it 'renders show index' do
      expect(response).to render_template :index
    end
  end
end
