require 'rails_helper'

feature 'User can creates answer', "
  Authenticated user can creates
  answer on current question
  without leaving the question
  page" do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    describe 'Authenticated user', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'can creates answer on current page' do
        fill_in 'answer[body]', with: 'New answer'
        click_on 'Add'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'New answer'
        end
      end

      scenario 'tries create invalid answer' do
        fill_in 'answer[body]', with: 'qwe'
        click_on 'Add'

        expect(page).to have_content 'Body is too short'
      end

      scenario 'can creates an answer with attached files' do
        fill_in 'answer[body]', with: 'New answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Add'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Unauthenticated user tries create answer on current page', js: true do
      visit question_path(question)

      fill_in 'answer[body]', with: 'New answer'
      click_on 'Add'

      expect(page).not_to have_content 'New answer'
    end
  end
