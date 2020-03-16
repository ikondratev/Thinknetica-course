require_relative '../acceptance_helper'

feature 'GuestUser registration via social networks', '
  In order to be able ask questions
  As an GuestUser
  I want to be able to registre via social networks
  ' do
  scenario 'New User registre via Facebook' do
    visit new_user_registration_path
    expect(page).to have_content('Sign in with Facebook')
    mock_auth_hash
    click_link 'Sign in with Facebook'
    expect(page).to have_content('mockuser_facebook')
  end

  scenario 'Existing User login via Facebook' do
    visit new_user_registration_path
    expect(page).to have_content('Sign in with Facebook')
    mock_auth_hash
    click_link 'Sign in with Facebook'
    expect(page).to have_content('mockuser_facebook')
  end

  scenario 'New User registre via GitHub' do
    visit new_user_registration_path
    expect(page).to have_content('Sign in with GitHub')
    mock_auth_hash
    click_link 'Sign in with GitHub'
    expect(page).to have_content('mockuser_github')
  end

  scenario 'Existing User login via GitHub' do
    visit new_user_registration_path
    expect(page).to have_content('Sign in with GitHub')
    mock_auth_hash
    click_link 'Sign in with GitHub'
    expect(page).to have_content('mockuser_github')
  end

  scenario 'New User registre via Twitter' do
    visit new_user_registration_path
    expect(page).to have_content('Sign in with Twitter')
    mock_auth_hash
    click_link 'Sign in with Twitter'
    expect(page).to have_content('please enter email') # user name
    fill_in 'email', with: 'user@test.com'
    click_on 'save'
    expect(page).to have_content('Successfully authenticated from Twitter account')
  end

  describe 'Existing User login via Twitter' do
    given(:user) { create(:user) }
    given!(:auth) { OmniAuth.config.mock_auth[:twitter] }
    given(:email) { 'user@test.com' }

    scenario 'Existing User login via Twitter' do
      user = create(:user, email: email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid, confirmed_at: Time.zone.now)

      visit new_user_registration_path
      expect(page).to have_content('Sign in with Twitter')
      mock_auth_hash
      click_link 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account')
    end
  end
end
