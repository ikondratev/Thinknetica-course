require 'rails_helper'

feature 'User can sign in', "
	In order to ask questions
	As an unauthenticated User
	I'd like to be able to sign in
" do
  given(:user) { create(:user) }
  before { visit new_user_session_path }

  scenario 'Registred user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistrered user tries to sign in' do
    fill_in 'Email', with: 'wrong_mail@mail.mail'
    fill_in 'Password', with: '12345678910'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
