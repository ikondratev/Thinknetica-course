require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:params) do
    { question_id: question.id, comment: { body: 'some body' } }
  end
  let(:invalid_params) do
    { question_id: question.id, comment: { body: '' } }
  end

  describe 'POST #create' do
    context 'Authenticated user tries' do
      before { login(user) }

      context 'with valid attributes' do
        it 'save the comment' do
          expect { post :create, params: invalid_params, format: :js }.not_to change(question.comments, :count)
        end

        it 'created comment belongs to current user' do
          post :create, params: params, format: :js
          expect(assigns(:comment).user_id).to eq user.id
        end

        it 'renders create' do
          post :create, params: params, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'dont save comment' do
          expect { post :create, params: invalid_params, format: :js }.not_to change(Comment, :count)
        end

        it 'renders create' do
          post :create, params: invalid_params, format: :js
          expect(response).to render_template :create
        end
      end
    end

    it 'Not Authenticated user tries add comment' do
      expect { post :create, params: params, format: :js }.not_to change(Comment, :count)
    end
  end
end
