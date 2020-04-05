require_relative '../acceptance_helper'

feature 'User login', "
  In order to be able ask questions
  As an User
  I want to be able to login
" do
  given(:user) { create(:user) }

  scenario 'Registred user try to login' do
    sign_in(user)

    expect(page).to have_content 'Signed in'
    expect(current_path).to eq root_path
  end

  scenario 'UnRegisterd user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end
