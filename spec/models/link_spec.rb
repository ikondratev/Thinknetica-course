require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:gist_url) { 'https://gist.github.com/ikondratev/971c500ba93c020ff0ea36e3bbcb66f8' }
  let(:img_url) { 'https://yadi.sk/i/XzxXqOF9SJ5yjg' }
  let(:gist_link) { Link.new(name: 'name', url: gist_url, linkable: question) }
  let(:img_link) { Link.new(name: 'name', url: img_url, linkable: question) }

  describe 'method gist?' do
    it "it is gist" do
      expect(gist_link).to be_gist
    end

    it "it is not gist" do
      expect(img_link).not_to be_gist
    end
  end

  describe 'method gist_content' do
    it "it is gist" do
      expect(gist_link.gist_content).to eq 'Hello world'
    end

    it "it is not gist" do
      expect(img_link.gist_content).to eq nil
    end
  end
end
