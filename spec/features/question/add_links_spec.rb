require 'rails_helper'

feature 'User can add links to question', "
	In order to provide additional info to my question
	As an question's author
	I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ikondratev/971c500ba93c020ff0ea36e3bbcb66f8' }
  given(:question) { create(:question, user: user) }
  given(:img_url) { 'https://yadi.sk/i/XzxXqOF9SJ5yjg' }

  describe 'Authenticated user can asks question and' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'adds invalid link', js: true do
      fill_in 'question[title]', with: 'New test title'
      fill_in 'question[body]', with: 'New test body text'

      click_on 'Add link'
      fill_in 'Link name', with: 'Gist'
      fill_in 'Url', with: 'bla bla bla ya hochu spat'

      click_on 'Ask'

      expect(page).to have_content "is not a valid URL"
      expect(page).not_to have_link 'Gist'
    end

    scenario 'adds gist link', js: true do
      fill_in 'question[title]', with: 'New test title'
      fill_in 'question[body]', with: 'New test body text'

      click_on 'Add link'
      fill_in 'Link name', with: 'Gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_content "Hello world"
    end
  end

  describe 'Authenticated user edit question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds link', js: true do
      click_on 'edit'
      within('#question_links') do
        click_on 'Add link'
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: gist_url
      end

      click_on 'save'
      expect(page).to have_link 'My link', href: gist_url
    end
  end
end
