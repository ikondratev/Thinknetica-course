require 'rails_helper'

feature 'User can edit own answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }

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
      end
    end

    scenario 'edits own answer with error' do
      sign_in(user)
      visit question_path(question)

      click_on 'edit'

      within '.answers' do
        fill_in 'answer[body]', with: 'new'
        click_on 'save'
        expect(page).to have_content(answer.body)
      end
      expect(page).to have_content 'Body is too short (minimum is 5 characters)'
    end

    scenario "user can not see edit if it is not his answer" do
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'edit'
      end
    end

    scenario 'edits own answer with attached files' do
      sign_in(user)
      visit question_path(question)

      click_on 'edit'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
