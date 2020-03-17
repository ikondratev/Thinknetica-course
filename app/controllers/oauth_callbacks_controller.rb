class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth_social('Github')
  end

  def facebook
  	auth_social('Facebook')
  end

  private 

  def auth_social(name)
     @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notie, :success, kind: name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end
end
