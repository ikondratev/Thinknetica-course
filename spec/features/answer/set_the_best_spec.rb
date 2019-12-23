require 'rails_helper'

feature 'User can select one of the answers as best', "
  Authenticeted uaser in order as author
  can select one of answers as the best
" do
  given!(:question) { create(:question, :with_answer) }

  context 'As authenticated user' do
    given(:user) { question.user }
    given(:other_user) { create(:user) }

    scenario 'as author can select answer as the best', js: true do
      sign_in(user)
      visit question_path(question)

      within("#answer-#{question.answers[-1].id}") do
        click_link('best')

        expect(page).to have_content 'The best'
      end
    end

    scenario 'as an author can change the best answer on other', js: true do
      sign_in(user)
      visit question_path(question)

      within("#answer-#{question.answers[-1].id}") do
        click_link('best')

        expect(page).to have_content 'The best'
      end

      within("#answer-#{question.answers[-2].id}") do
        click_link('best')

        expect(page).to have_content 'The best'
      end
    end

    scenario 'can not see best button on alien question answer', js: true do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'best'
    end
  end

  context 'As unauthenticated user' do
    scenario 'can not see best button' do
      visit question_path(question)

      expect(page).to_not have_link 'best'
    end
  end
end
