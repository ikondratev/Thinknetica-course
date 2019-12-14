require 'rails_helper'

feature 'User can log out', "
  registred user can ending session
  and user can log-out
" do
  given(:user) { create(:user) }

  scenario 'user can logout' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
