require 'rails_helper'

feature 'User can edit own answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unautheticated user can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits own answer' do
      sign_in(user)
      visit question_path(question)

      click_on 'edit'

      within '.answers' do
        fill_in 'answer[body]', with: 'new line body'
        click_on 'save'

        expect(page).to_not have_content(answer.body)
        expect(page).to have_content 'new line body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits own answer with error' do
    end

    scenario "tries edit other's user answer" do
    end
  end
end
