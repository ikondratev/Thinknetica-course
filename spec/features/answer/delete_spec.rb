require 'rails_helper'

feature 'User can delete answer', "
  authenticated user who created
  aswer can delete this answer
" do
  given(:answer) { create(:answer) }
  given(:user) { create(:user) }

  scenario 'only authenticated author of answer can delete answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)
    click_on 'Delete answer'

    expect(page).not_to have_content(answer.body)
  end

  scenario 'only authenticated author can see delete button' do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).not_to have_content 'Delete answer'
  end

  scenario 'unauthenticated user can not see delete button' do
    visit question_path(answer.question)

    expect(page).not_to have_content 'Delete answer'
  end
end
