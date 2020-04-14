require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API autorizable' do
      let(:method) { :get }
    end

    context 'autorize' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:questions_response) { json['questions'] }
      let(:question_response) { json['questions'].first }
      let(:items) { %w[title body created_at updated_at] }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Returns response status', 200

      it_behaves_like 'Returns list of objects', 2, 'questions_response'

      it_behaves_like 'Returns all public fields', 'question_response', 'question'

      it 'returns user obj' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'returns short title' do
        expect(question_response['short_title']).to eq question.title.truncate(5)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }
        let(:items) { %w[id body created_at updated_at] }

        it_behaves_like 'Returns list of objects', 3, 'answers'

        it_behaves_like 'Returns all public fields', 'answer_response', 'answer'
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { '/api/v1/questions/1' }

    it_behaves_like 'API autorizable' do
      let(:method) { :get }
    end

    context 'autorize' do
      let!(:question) { create(:question) }
      let(:question_response) { json['question'] }
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:link) { create(:link, linkable: question) }
      let(:items) { %w[title body created_at updated_at] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it_behaves_like 'Returns all public fields', 'question_response', 'question'

      it 'returns this question' do
        expect(question_response['id']).to eq question.id
      end

      context 'with comment' do
        let(:response_comments) { question_response['comments'] }
        let(:response_comment) { response_comments.first }
        let(:items) { %w[body created_at updated_at] }

        it 'returns question with comment' do
          expect(question_response['comments'].first['id']).to eq question.comments.first.id
        end

        it_behaves_like 'Returns all public fields', 'response_comment', 'comment'
      end

      context 'with link' do
        let(:response_links) { question_response['links'] }
        let(:response_link) { response_links.first }
        let(:items) { %w[name url created_at updated_at] }

        it 'returns question with link' do
          expect(response_link['id']).to eq question.links.first.id
        end

        it_behaves_like 'Returns all public fields', 'response_link', 'link'
      end
    end
  end

  describe 'POST /create' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API autorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let!(:question) { create(:question) }
      let(:access_token) { create(:access_token) }

      before { post api_path, params: { question: attributes_for(:question), access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it 'create question' do
        expect { post api_path, params: { question: attributes_for(:question), access_token: access_token.token } }.to change(Question, :count).by(1)
      end
    end
  end

  describe 'PATHC /update' do
    let(:api_path) { '/api/v1/questions/1' }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API autorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { patch "/api/v1/questions/#{question.id}", params: { format: :json, question: attributes_for(:question), access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it 'update question' do
        patch "/api/v1/questions/#{question.id}", params: { format: :json, question: { 'title' => 'New some title', 'body' => 'new some bodY' }, access_token: access_token.token }
        expect(json['question']['id']).to eq question.id
        expect(json['question']['body']).not_to eq question.body
        expect(json['question']['title']).not_to eq question.title
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:api_path) { '/api/v1/questions/1' }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:second_question) { create(:question, user: user) }

    it_behaves_like 'API autorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { delete "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Returns response status', 200

      it 'delete question' do
        expect { delete "/api/v1/questions/#{second_question.id}", params: { format: :json, access_token: access_token.token } }.to change(Question, :count).by(-1)
      end
    end
  end
end
