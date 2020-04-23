require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Link }
    it { should be_able_to :create, File }
    it { should be_able_to :create, Gift }

    context 'update' do
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other_user), user: user }

      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

      it { should be_able_to :update, create(:link, linkable: question), user: user }
      it { should_not be_able_to :update, create(:link, linkable: other_question), user: user }
    end

    context 'set the best answer' do
      it { should be_able_to :set_the_best, create(:answer, question: question), user: user }
      it { should_not be_able_to :set_the_best, create(:answer, question: other_question), user: user }
    end

    context 'destroy' do
      it { should be_able_to :destroy, create(:question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }
      it { should be_able_to :destroy, create(:answer, user: user), user: user }
      it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }
      it { should be_able_to :destroy, create(:link, linkable: question), user: user }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question), user: user }
    end

    context 'set like' do
      it { should be_able_to :like, other_question, user: user }
      it { should_not be_able_to :like, question, user: user }
    end

    context 'set dislike' do
      it { should be_able_to :dislike, other_question, user: user }
      it { should_not be_able_to :dislike, question, user: user }
    end

    context 'subscribe' do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:subscription) { question.subscriptions.new(user: other_user) }

      context 'can subscribe' do
        it { should be_able_to :create, Subscription, subscription, user: other_user }
      end

      context 'can not subscribe' do
        it { should_not be_able_to :create, subscription, Subscription, user: user }
      end
    end
  end
end
