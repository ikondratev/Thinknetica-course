require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assign new subscriptio' do
      expect(assigns(:subscription)).to be_a_new(Subscription)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new link to question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'rendering page edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:create_valid_question) do
      post :create, params: { question: attributes_for(:question) }
    end

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { create_valid_question }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        create_valid_question
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'assosiated question with current user' do
        create_valid_question
        expect(assigns(:question).user_id).to eq user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) }, format: :js }.to_not change(Question, :count)
      end

      it 're-renders create' do
        post :create, params: { question: attributes_for(:question, :invalid), format: :js }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(question.user) }

    let(:update_question) do
      patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
    end

    context 'with valid attributes' do
      before { update_question }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change title of question' do
        question.reload

        expect(question.body).to eq question.body
      end

      it 'does not change body of question' do
        question.reload
        expect(question.body).to eq question.body
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_question) { delete :destroy, params: { id: question } }
    before { question }

    context 'if user author of question' do
      before { login(question.user) }

      it 'delete question from db' do
        expect { delete_question }.to change(Question, :count).by(-1)
      end

      it 'redirect on questions page' do
        delete_question
        expect(response).to redirect_to questions_path
      end
    end

    context 'if user is not author of question' do
      before { login(user) }

      it 'does not delete question from bd' do
        expect { delete_question }.to_not change(Question, :count)
      end
    end
  end
end
