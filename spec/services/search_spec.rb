require 'rails_helper'

RSpec.describe SearchService do
  describe '#search' do
    context 'it started ThinkingSphinx' do
      it 'when thing not adding' do
        expect(ThinkingSphinx).to receive(:search).with('test\\@test.com').and_call_original
        SearchService.search_by('test@test.com')
      end

      it 'when thing not exist' do
        expect(ThinkingSphinx).to receive(:search).with('Query').and_call_original
        SearchService.search_by('Query', 'Car')
      end
    end

    %w[Question Answer User Comment].each do |attr|
      it "Started service with #{attr} thing" do
        expect(attr.constantize).to receive(:search).with('test\\@test.com').and_call_original
        SearchService.search_by('test@test.com', attr.to_s)
      end
    end

    it 'return nothing#blank' do
      expect(SearchService.search_by('', 'Answer')).to eq []
    end
  end
end
