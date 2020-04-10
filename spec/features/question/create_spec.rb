require 'rails_helper'

feature 'User can create question', "
	In order to get answer from a community
	As an authenticates User
	I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'can asks a question' do
      fill_in 'question[title]', with: 'New test title'
      fill_in 'question[body]', with: 'New test body text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'New test title'
      expect(page).to have_content 'New test body text'
    end

    scenario 'asks a question with error' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'question[title]', with: 'New test title'
      fill_in 'question[body]', with: 'New test body text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question and create gift' do
      fill_in 'question[title]', with: 'New test title'
      fill_in 'question[body]', with: 'New test body text'

      fill_in 'Gift name', with: 'Gift name'
      attach_file 'Image', "#{Rails.root}/spec/images/gift.jpg"
      click_on 'Ask'

      expect(page).to have_content 'Gift name'
      expect(page).to have_css("img[src*='gift.jpg']")
    end

    scenario 'delete attached files' do
      fill_in 'question[title]', with: 'New test title'
      fill_in 'question[body]', with: 'New test body text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Ask'

      click_on 'delete file'

      expect(page).not_to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).not_to have_content 'Ask question'
  end

  context "Multiple sessions", js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'question[title]', with: 'New test title'
        fill_in 'question[body]', with: 'New test body text'
        click_on 'Ask'
        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'New test title'
        expect(page).to have_content 'New test body text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New test title'
      end
    end
  end
end
