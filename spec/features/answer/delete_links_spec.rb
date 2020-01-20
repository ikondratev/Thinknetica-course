require 'rails_helper'

feature 'Author can delete links from answer', "
  As an answer's author
  I'd like to be able to delete links
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

    scenario 'can delete link', js: true do
      fill_in 'answer[body]', with: 'New answer'

      click_on 'Add link'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add'

      click_on 'edit'

      click_on 'Delete link'

      expect(page).not_to have_link 'My gist'
    end
  end
end
