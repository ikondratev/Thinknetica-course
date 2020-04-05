class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authorize_with('Github')
  end

  def facebook
    authorize_with('Facebook')
  end

  def twitter
    authorize_with('Twitter')
  end

  private

  def authorize_with(name)
    @name = name
    @auth = request.env['omniauth.auth']

    @name == 'Twitter' ? email_not_present : email_present
  end

  def email_present
    @user = User.find_for_oauth(@auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notie, :success, kind: @name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end

  def email_not_present
    @user = User.find_for_oauth(@auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notie, :success, kind: @name) if is_navigational_format?
    else
      render "authorizations/new"
    end
  end
end
