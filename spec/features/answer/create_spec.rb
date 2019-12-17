require 'rails_helper'

feature 'User can creates answer', "
  Authenticated user can creates
  answer on current question
  without leaving the question
  page" do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'authenticated user can creates answer on current page', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'answer[body]', with: 'New answer'
      click_on 'Add'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'New answer'
      end
    end

    scenario 'authenticated user tries create invalid answer', js: true do
      sign_in(question.user)
      visit question_path(question)

      fill_in 'answer[body]', with: 'qwe'
      click_on 'Add'

      expect(page).to have_content 'Body is too short'
    end

    scenario 'unauthenticated user tries create answer on current page', js: true do
      visit question_path(question)

      fill_in 'answer[body]', with: 'New answer'
      click_on 'Add'

      expect(page).not_to have_content 'New answer'
    end
  end
