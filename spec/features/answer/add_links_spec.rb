require 'rails_helper'

feature 'User can add links to answer', "
	In order to provide additional info to my question
	As an answer's author
	I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/ikondratev/971c500ba93c020ff0ea36e3bbcb66f8' }
  given(:img_url) { 'https://yadi.sk/i/XzxXqOF9SJ5yjg' }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can adds link when send answer', js: true do
      fill_in 'answer[body]', with: 'New answer'

      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'can not adds invalid link', js: true do
      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'spaaaaat'

      click_on 'Add'

      expect(page).to have_content "Links url is not a valid URL"
      expect(page).not_to have_link 'My gist'
    end

    scenario 'can adds gist link', js: true do
      fill_in 'answer[body]', with: 'New answer'

      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add'

      expect(page).to have_content 'Hello world'
    end
  end

  describe 'Authenticated user edit his answer' do
    scenario 'adds link', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'edit'

      within '.answers' do
        click_on 'Add link'

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: gist_url
      end

      click_on 'save'
      expect(page).to have_link 'My link', href: gist_url
    end
  end
end
