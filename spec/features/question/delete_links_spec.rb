require 'rails_helper'

feature 'Author can delete links from question', "
  As an question's author
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }
  given(:foreign_question) { create(:question, user: another_user) }
  given!(:link) { create :link, linkable: question }
  given!(:foreign_link) { create :link, linkable: foreign_question }

  scenario 'Unauthenticated can not delete links' do
    sign_in(user)
    visit question_path(foreign_question)
    expect(page).to_not have_link 'edit'
  end

  describe 'Authenticated user' do
    background { sign_in user }

    scenario 'delete link from his question', js: true do
      visit question_path(question)
      click_on 'edit'

      within('#question_links') do
        expect(page).to have_field('Link name', with: 'My link')
        click_on 'Delete link'
      end
      click_on 'save'
      expect(page).not_to have_link 'MyString'
    end

    scenario 'delete link from foreign question', js: true do
      visit question_path(foreign_question)
      expect(page).to_not have_link 'edit'
      expect(page).to_not have_link 'Delete link'
    end
  end
end
