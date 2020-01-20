require 'rails_helper'

feature "User can get gift when his answer best", "
  As an user
  I'd like to be able to get gifted
" do
  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:gift) { create(:gift, question: question) }

  background do
    sign_in user
    visit question_path(question)
  end

  describe 'User can get gift', js: true do
    scenario 'can see gift on question page' do
      within(".answers") do
        click_on 'best'
        expect(page).to have_content gift.name
        expect(page).to have_css("img[src*='gift.jpg']")
      end
    end

    scenario "can see gift ongift's page" do
      within(".answers") do
        click_on 'best'
      end
      visit gifts_path
      expect(page).to have_content gift.name
      expect(page).to have_css("img[src*='gift.jpg']")
    end
  end
end
