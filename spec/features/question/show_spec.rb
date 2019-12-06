require 'rails_helper'

feature 'User can view the question', "
  Any user can
  view the selected
  question.
" do
  given(:user) { create(:user) }

  describe 'If question without answer(s)' do
    given(:question_without_answer) { create(:question) }

    scenario 'authenticated user can views the question' do
      sign_in(user)
      visit question_path(question_without_answer)

      expect(page).to have_content(question_without_answer.title)
      expect(page).to have_content(question_without_answer.body)
      expect(current_path).to eq question_path(question_without_answer)
    end

    scenario 'unauthenticated user can views the question' do
      visit question_path(question_without_answer)

      expect(page).to have_content(question_without_answer.title)
      expect(page).to have_content(question_without_answer.body)
      expect(current_path).to eq question_path(question_without_answer)
    end
  end

  describe 'If question with answer(s)' do
    given(:question_with_answer) { create(:question, :with_answer) }

    scenario 'authenticated user can views the question' do
      sign_in(user)
      visit question_path(question_with_answer)

      expect(question_with_answer.answers.any?).to be_truthy
      expect(page).to have_content(question_with_answer.title)
      expect(page).to have_content(question_with_answer.body)
      expect(current_path).to eq question_path(question_with_answer)
      question_with_answer.answers.each do |a|
        expect(page).to have_content(a.body)
      end
    end

    scenario 'unauthenticated user can views the question' do
      visit question_path(question_with_answer)

      expect(question_with_answer.answers.any?).to be_truthy
      expect(page).to have_content(question_with_answer.title)
      expect(page).to have_content(question_with_answer.body)
      expect(current_path).to eq question_path(question_with_answer)
      question_with_answer.answers.each do |a|
        expect(page).to have_content(a.body)
      end
    end
  end
end
