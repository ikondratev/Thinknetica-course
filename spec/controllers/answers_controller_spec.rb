require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:valid_create_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end

    let(:invalid_create_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
    end

    before { login(user) }

    context 'with valid attributes' do
      it 'saved new answer in db' do
        expect { valid_create_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to associated question' do
        valid_create_answer
        expect(response).to redirect_to question
      end

      it 'associated answer with current user' do
        valid_create_answer
        expect(assigns(:answer).user_id).to eq user.id
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save invalid answer in db' do
        expect { invalid_create_answer }.to_not change(Answer, :count)
      end

      it 're randers new view' do
        invalid_create_answer
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    let(:delete_answer) { delete :destroy, params: { question_id: answer.question.id, id: answer } }

    context 'if it is an author of answer' do
      before { login answer.user }

      it 'deletes an answer' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 're-directs to question' do
        delete_answer
        expect(response).to redirect_to answer.question
      end
    end

    context 'if it is not an author of answer' do
      before { login(user) }

      it 'doesnt delete asnwer' do
        expect { delete_answer }.not_to change(Answer, :count)
      end

      it 're-directs to question' do
        delete_answer
        expect(response).to redirect_to answer.question
      end
    end
  end
end
