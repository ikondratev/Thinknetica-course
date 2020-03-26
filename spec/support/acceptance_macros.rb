module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def create_question
    visit questions_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'
  end
end
