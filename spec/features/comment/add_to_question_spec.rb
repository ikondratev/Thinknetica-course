require 'rails_helper'

feature 'User can create comment', "
  Authenticated user can creates
  comment on oquestion page
  " do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Post a comment' do
      within '#question' do
        fill_in 'Your comment', with: 'test comment'
        click_on 'Post comment'
      end
      expect(page).to have_content 'test comment'
    end

    scenario 'Post a comment with errors' do
      within '#question' do
        click_on 'Post comment'
      end
      expect(page).to have_content "can't be blank"
    end
  end

  scenario "Unauthenticated user can't post a comment" do
    visit question_path(question)
    within '#question' do
      expect(page).not_to have_content 'Your comment'
    end
  end

  scenario "Post question's comment appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within '#question' do
        fill_in 'Your comment', with: 'Test text'
        click_on 'Post comment'
      end
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test text'
    end
  end
end
