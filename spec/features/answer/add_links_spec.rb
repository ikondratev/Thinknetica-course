require 'rails_helper'

feature 'User can add links to answer', "
	In order to provide additional info to my question
	As an answer's author
	I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/ikondratev/971c500ba93c020ff0ea36e3bbcb66f8' }

  scenario 'User adds link when send answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'answer[body]', with: 'New answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
