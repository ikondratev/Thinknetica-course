require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :voteable }
  it { should belong_to :user }

  it { should validate_presence_of :count }
  it { should validate_inclusion_of(:count).in_array(%w[-1 0 1]) }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:vote) { Vote.create(user: another_user, voteable: question) }
  let(:not_valid_vote) { Vote.new(user: user, voteable: question) }

  it 'should default count to 0' do
    expect(vote.count).to eq 0
  end

  describe 'like!' do
    it "when count 0" do
      vote.like!
      expect(vote.count).to eq 1
    end

    it "when count 1" do
      vote.count = 1
      vote.like!
      expect(vote).to be_destroyed
    end

    it "when count -1" do
      vote.count = -1
      vote.like!
      expect(vote.count).to eq 1
    end
  end

  describe 'dislike!' do
    it "when count 0" do
      vote.dislike!
      expect(vote.count).to eq -1
    end

    it "when count 1" do
      vote.count = 1
      vote.dislike!
      expect(vote.count).to eq -1
    end

    it "when count -1" do
      vote.count = -1
      vote.dislike!
      expect(vote).to be_destroyed
    end
  end

  describe 'validate method cannot_revoting' do
    it "if valid vote" do
      vote.valid?
      expect(vote.errors[:user]).not_to include("can't revoiting")
    end

    it "if not valid vote" do
      not_valid_vote.valid?
      expect(not_valid_vote.errors[:user]).to include("can't revoiting")
    end
  end
end
