require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'Post #create' do
    let!(:question) { create(:question) }

    subject do
      post :create, params: { question_id: question.id }
    end

    describe 'authenticated user' do
      before { login(user) }

      context 'create subscription' do
        it_behaves_like 'change count object', Subscription, 1

        it 'create subscribe with current user' do
          correct_user = question.user
          subject
          expect(Subscription.first.user).to eq correct_user
        end
      end
    end

    context 'unauthenticated user' do
      it_behaves_like 'not change count object', Subscription
    end

    context "tries create a subscription a second time" do
      before do
        question.subscribe(user)
        login(user)
      end

      it_behaves_like 'not change count object', Subscription

      it 'redirect to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'Delete #destroy' do
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, question: question, user: user) }

    subject do
      delete :destroy, params: { question_id: question }
    end

    describe 'authenticated user' do
      before { login(user) }

      context 'delete subscription' do
        it_behaves_like 'change count object', Subscription, -1
      end
    end

    context 'unauthenticated user' do
      it_behaves_like 'not change count object', Subscription
    end

    describe 'another user' do
      before { login(another_user) }

      context 'another user ' do
        it 'can not delete another user subscription' do
          subject
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
