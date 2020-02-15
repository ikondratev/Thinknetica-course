require 'rails_helper'

feature 'User can add vote', "
  As an authenticated user
  I'd like to br able vote
  answer
  " do
    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:another_answer) { create(:answer, question: question, user: another_user) }
    given(:user_delete) { create(:user) }
    given(:question_delete) { create(:question) }
    given(:answer_delete) { create :answer, question: question_delete }
    given(:like) { create :vote, user: user_delete, voteable: answer_delete, count: 1 }
    given(:dislike) { create :vote, user: user_delete, voteable: answer_delete, count: -1 }

    describe 'Unauthenticated user' do
      scenario 'can not add like to answer' do
        visit question_path(question)

        within ".answers" do
          expect(page).not_to have_link 'like'
        end
      end

      scenario 'can not add dislike to answer' do
        visit question_path(question)

        within ".answers" do
          expect(page).not_to have_link 'dislike'
        end
      end
    end

    describe 'Authenticated user' do
      # background { sign_in(user) }

      scenario 'tries add like to own answer' do
        sign_in(user)
        visit question_path(question)

        within "#answer-#{answer.id} .answer-score" do
          expect(page).not_to have_link 'like'
        end
      end

      scenario 'tries add dislike to own answer' do
        sign_in(user)
        visit question_path(question)

        within "#answer-#{answer.id} .answer-score" do
          expect(page).not_to have_link 'dislike'
        end
      end

      scenario 'tries add like to another answer', js: true do
        sign_in(user)
        visit question_path(question)

        within "#answer-#{another_answer.id} .answer-score" do
          expect(page).to have_content '0'
          click_on 'like'
        end

        within("#answer-#{another_answer.id} .score") { expect(page).to have_content '1' }
      end

      scenario 'tries add dislike to another answer', js: true do
        sign_in(user)
        visit question_path(question)

        within "#answer-#{another_answer.id} .answer-score" do
          expect(page).to have_content '0'
          click_on 'dislike'
        end

        within("#answer-#{another_answer.id} .score") { expect(page).to have_content '-1' }
      end

      scenario 'tries destroy like to another answer', js: true do
        sign_in(user_delete)
        like
        visit question_path(question_delete)

        within "#answer-#{answer_delete.id} .answer-score" do
          expect(page).to have_content '1'
          click_on 'like'
        end

        within("#answer-#{answer_delete.id} .score") { expect(page).to have_content '0' }
      end

      scenario 'tries destroy dislike to another answer', js: true do
        sign_in(user_delete)
        dislike
        visit question_path(question_delete)

        within "#answer-#{answer_delete.id} .answer-score" do
          expect(page).to have_content '-1'
          click_on 'dislike'
        end

        within("#answer-#{answer_delete.id} .score") { expect(page).to have_content '0' }
      end
    end
  end
