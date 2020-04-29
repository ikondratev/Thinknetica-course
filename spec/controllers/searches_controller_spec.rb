require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    it 'call SearchServiceh#search_by' do
      expect(SearchService).to receive(:search_by).with('Query', 'Type')
      get :index, params: { query: 'Query', type: 'Type' }
    end

    it 'renders index view' do
      get :index, params: { query: 'Query', type: 'Type' }
      expect(response).to render_template :index
    end
  end
end
