require 'rails_helper'

feature 'User can add vote', "
  As an authenticated user
  I'd like to br able vote
  question
  " do
    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given(:another_question) { create(:question, user: another_user) }

    given(:like) { create :vote, user: another_user, voteable: question, count: 1 }
    given(:dislike) { create :vote, user: another_user, voteable: question, count: -1 }

    describe 'Unauthenticated user' do
      scenario 'can not add like to question' do
        visit question_path(question)
        expect(page).not_to have_link 'like'
      end

      scenario 'can not add dislike to question' do
        visit question_path(question)
        expect(page).not_to have_link 'dislike'
      end
    end

    describe 'Authenticated user' do
      # background { sign_in(user) }

      scenario 'tries add like to own question' do
        sign_in(user)
        visit question_path(question)
        expect(page).not_to have_link 'like'
      end

      scenario 'tries add dislike to own question' do
        sign_in(user)
        visit question_path(question)
        expect(page).not_to have_link 'dislike'
      end

      scenario 'tries add like to another question', js: true do
        sign_in(user)
        visit question_path(another_question)
        expect(page).to have_content '0'
        click_on 'like'

        within('.score') { expect(page).to have_content '1' }
      end

      scenario 'tries add dislike to another question', js: true do
        sign_in(user)
        visit question_path(another_question)
        expect(page).to have_content '0'
        click_on 'dislike'

        within('.score') { expect(page).to have_content '-1' }
      end

      scenario 'tries to destroy like', js: true do
        sign_in(another_user)

        like
        visit question_path(question)
        within('.question-score') do
          expect(page).to have_content '1'
          click_on "like"
        end
        within('.score') { expect(page).to have_content '0' }
      end

      scenario 'tries to destroy dislike', js: true do
        sign_in(another_user)

        dislike
        visit question_path(question)
        within('.question-score') do
          expect(page).to have_content '-1'
          click_on "dislike"
        end
        within('.score') { expect(page).to have_content '0' }
      end
    end
  end
