require 'rails_helper'

feature 'User can edit own question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Unautheticated user can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits own question' do
      sign_in(user)
      visit question_path(question)

      click_on 'edit'

      within '.question' do
        fill_in 'question[body]', with: 'new line body'
        click_on 'save'

        expect(page).to_not have_content(question.body)
        expect(page).to have_content 'new line body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits own question with error' do
      sign_in(user)
      visit question_path(question)

      click_on 'edit'

      within '.question ' do
        fill_in 'question[body]', with: ''
        click_on 'save'
        expect(page).to have_content(question.body)
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "user can not see edit if it is not his question" do
      sign_in(other_user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'edit'
      end
    end
  end
end
