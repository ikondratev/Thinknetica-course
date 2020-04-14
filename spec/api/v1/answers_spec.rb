require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/answers/id' do
    let(:api_path) { '/api/v1/answers/1' }

    it_behaves_like 'API autorizable' do
      let(:method) { :get }
    end

    context 'autorize' do
      let(:question) { create(:question) }
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:link) { create(:link, linkable: answer) }
      let(:items) { %w[body created_at updated_at] }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it_behaves_like 'Returns all public fields', 'answer_response', 'answer'

      it 'returns own answer' do
        expect(answer_response['id']).to eq answer.id
      end

      context 'with comment' do
        let(:items) { %w[body commentable_type commentable_id created_at updated_at] }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns answer with comment' do
          expect(comment_response['id']).to eq comment.id
        end

        it_behaves_like 'Returns all public fields', 'comment_response', 'comment'
      end

      context 'with link' do
        let(:items) { %w[name url linkable_type linkable_id created_at updated_at] }
        let(:link_response) { answer_response['links'].first }

        it 'returns answer with link' do
          expect(link_response['id']).to eq link.id
        end

        it_behaves_like 'Returns all public fields', 'link_response', 'link'
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { '/api/v1/questions/1/answers' }

    it_behaves_like 'API autorizable' do
      let(:method) { :get }
    end

    context 'autorize' do
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answers_response) { json['answers'] }
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      context 'with answers' do
        let(:items) { %w[body created_at updated_at] }
        let(:answer_response) { answers_response.first }

        it_behaves_like 'Returns list of objects', 2, 'answers_response'

        it_behaves_like 'Returns all public fields', 'answer_response', 'answer'
      end
    end
  end

  describe 'POST #create' do
    let(:api_path) { '/api/v1/questions/1/answers' }

    it_behaves_like 'API autorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question) }
      let(:access_token) { create(:access_token) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it 'create answer' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), access_token: access_token.token } }.to change(Answer, :count).by(1)
      end
    end
  end

  describe 'PATHC /update' do
    let(:api_path) { '/api/v1/answers/1' }
    let(:user) { create(:user) }

    it_behaves_like 'API autorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question, user: user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { patch "/api/v1/answers/#{answer.id}", params: { answer: attributes_for(:answer), access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it 'update question' do
        patch "/api/v1/answers/#{answer.id}", params: { answer: { 'body' => 'New test body!' }, access_token: access_token.token }
        expect(json['answer']['id']).to eq answer.id
        expect(json['answer']['body']).not_to eq answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:api_path) { '/api/v1/answers/1' }
    let(:user) { create(:user) }

    it_behaves_like 'API autorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }
      let!(:another_answer) { create(:answer, question: question, user: user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it 'delete question' do
        expect { delete "/api/v1/answers/#{another_answer.id}", params: { access_token: access_token.token } }.to change(question.answers, :count).by(-1)
      end
    end
  end
end
