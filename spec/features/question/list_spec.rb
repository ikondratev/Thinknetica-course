require 'rails_helper'

feature 'User can view a list of questions', %(
	In order to get answer from a community
	I'd like to be able to view a list of questions
) do
  given(:user) { create(:user) }

  given!(:questions) { create_list(:question, 3) }

  describe 'autheticated user can' do
    scenario 'views list of questions' do
      sign_in(user)
      visit questions_path

      questions.each { |question| expect(page).to have_content(question.title) }
    end
  end

  describe 'unauthenticated user can' do
    scenario 'views list of quesstions' do
      visit questions_path

      questions.each { |question| expect(page).to have_content(question.title) }
    end
  end
end
