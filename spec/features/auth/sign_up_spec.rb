require 'rails_helper'

feature 'Unregistred user can sign up', "
  any unregistered user
  can go through the
  registration process
" do
  scenario 'unregistred user can sign up' do
    visit new_user_registration_path
    within 'form#new_user' do
      fill_in 'Email', with: 'test@test.test'
      fill_in 'Password', with: '12345678910'
      fill_in 'user[password_confirmation]', with: '12345678910'
      click_on 'Sign up'
    end

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
