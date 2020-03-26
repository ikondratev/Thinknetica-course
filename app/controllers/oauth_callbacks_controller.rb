class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    get_user_from('Github')
  end

  def facebook
    get_user_from('Facebook')
  end

  def twitter
    get_user_from('Twitter')
  end

  private

  def get_user_from(name)
    oauth = request.env['omniauth.auth']

    @user = User.find_for_oauth(oauth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notie, :success, kind: name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end
end
