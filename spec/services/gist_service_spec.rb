require 'rails_helper'

RSpec.describe "GistContentService" do
  let(:service_with_gist) { GistService.new('971c500ba93c020ff0ea36e3bbcb66f8') }
  let(:service_with_error_gist) { GistService.new('error_gist') }

  describe 'method content' do
    it "it is exist true gist" do
      expect(service_with_gist.content).to eq 'Hello world'
    end

    it "it is not exist gist" do
      expect(service_with_error_gist.content).to eq nil
    end
  end
end
