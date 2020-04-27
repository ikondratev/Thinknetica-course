require 'rails_helper'

feature 'User can unsubscribe to the question', "
  In order to not receive information about new answers
  As an authenticated user
  I'd like to be able unsubscribe from question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'own question' do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Unsubscribe'
    end

    scenario 'unsubscribes from the question' do
      expect(page).to have_content 'Unsubscribed successfully'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'not owner question' do
    background do
      question.subscribe(another_user)
      sign_in(another_user)
      visit question_path(question)
      click_on 'Unsubscribe'
    end

    scenario 'unsubscribes to the question' do
      expect(page).to have_content 'Unsubscribed successfully'
      expect(page).to have_link 'Subscribe'
    end
  end
end
