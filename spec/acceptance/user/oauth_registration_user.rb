require_relative '../acceptance_helper'

feature 'GuestUser registration via social networks', '
  In order to be able ask questions
  As an GuestUser
  I want to be able to registre via social networks
  ' do
  scenario 'New User registre via Twitter' do
    visit new_user_registration_path
    expect(page).to have_content('Sign in with Twitter')
    mock_auth_hash
    click_link 'Sign in with Twitter'
    expect(page).to have_content('please enter email') # user name
    fill_in 'email', with: 'user@test.com'
    click_on 'Enter'
    expect(page).to have_content('Successfully authenticated from Twitter account')
  end
end
