require 'rails_helper'

feature 'User can subscribe to the question', "
  In order to get information about new answers
  As an authenticated user
  I'd like to be able to information about any new answers
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(another_user)
      visit question_path(question)
      click_on 'Subscribe'
    end

    scenario 'can subscribes' do
      expect(page).to have_content 'Subscribed successfully'
      expect(page).to_not have_link 'Subscribe'
    end
  end

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
  end
end
