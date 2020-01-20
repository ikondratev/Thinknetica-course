require 'rails_helper'

feature 'User can add links to question', "
	In order to provide additional info to my question
	As an question's author
	I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ikondratev/971c500ba93c020ff0ea36e3bbcb66f8' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'question[title]', with: 'New test title'
    fill_in 'question[body]', with: 'New test body text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
