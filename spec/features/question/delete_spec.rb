require 'rails_helper'

feature 'user can delete question', "
  if user uthenticated
  and user is an author
  of the question,
  he can delete the question
" do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  let(:delete_question) do
    visit question_path(question)
    click_on 'Delete question'
  end

  context 'if user is autheticated' do
    scenario 'and user an athor, he can delete question' do
      sign_in(question.user)
      delete_question

      expect(page).not_to have_content(question.body)
      expect(page).to have_content 'Your question have been successfully destroyed.'
    end

    scenario 'and user is not athor, he can not see delete button' do
      sign_in(user)
      visit question_path(question)

      expect(page).not_to have_content 'Delete question'
    end
  end

  context 'if user is not autheticated' do
    scenario 'he can not see delete button' do
      visit question_path(question)

      expect(page).not_to have_content 'Delete question'
    end
  end
end
