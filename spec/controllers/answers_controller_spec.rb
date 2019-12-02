require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { question.answers.create(attributes_for(:answer)) }

  describe 'POST #create' do
    let(:valid_create_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end

    let(:invalid_create_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
    end

    context 'with valid attributes' do
      it 'saved new answer in db' do
        expect { valid_create_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to associated question' do
        valid_create_answer
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save invalid answer in db' do
        expect { invalid_create_answer }.to_not change(Answer, :count)
      end

      it 're randers new view' do
        invalid_create_answer
        expect(response).to render_template :new
      end
    end
  end
end
