require 'rails_helper'

feature 'User can create comment', "
  Authenticated user can creates
  comment on oquestion page
  " do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Post a comment' do
      within "#answer-#{answer.id}" do
        fill_in 'Your comment', with: 'test comment'
        click_on 'Post comment'
      end
      expect(page).to have_content 'test comment'
    end

    scenario 'Post a comment with errors' do
      within "#answer-#{answer.id}" do
        click_on 'Post comment'
      end
      expect(page).to have_content "can't be blank"
    end
  end

  scenario "Unauthenticated user can't post a comment" do
    visit question_path(question)
    within "#answer-#{answer.id}" do
      expect(page).not_to have_content 'Your comment'
    end
  end

  scenario "Post answer's comment on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within "#answer-#{answer.id}" do
        fill_in 'Your comment', with: 'Test text'
        click_on 'Post comment'
      end
    end

    Capybara.using_session('guest') do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Test text'
      end
    end
  end
end
