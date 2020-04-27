require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:gift).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :gift }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls Services::Reputation#calculate' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'self.for_digest' do
    let!(:questions) { create_list(:question, 4) }

    it 'return questions for digest' do
      expect(Question.for_digest.size).to eq 4
    end

    it 'return correct attributes' do
      expect(Question.for_digest.first.title).to eq questions.first.title
    end
  end

  describe 'self.subscribe' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    before do
      question.subscribe(other_user)
    end

    it 'create subscription for user' do
      expect(Subscription.last.user).to eq other_user
      expect(Subscription.last.question).to eq question
    end
  end

  describe 'self.un_subscribe' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    before do
      question.un_subscribe(user)
    end

    it 'unsubscribe for user' do
      expect(Subscription.first).to eq nil
    end
  end

  describe 'after_create #subscription' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'subscription on createt' do
      expect(question).to receive :subscription
      question.save
    end

    context 'create subscription' do
      let(:question) { create(:question, user: user) }

      before do
        question.subscribe(user)
      end

      it 'create subscription for user' do
        expect(Subscription.first.question).to eq question
        expect(Subscription.first.user).to eq user
      end
    end
  end
end
