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
    @auth = request.env['omniauth.auth']
    @authorization = Authorization.where(provider: @auth.provider, uid: @auth.uid.to_s).first

    if @authorization.present?
      sign_in_and_redirect User.find_for_oauth(@auth), event: :authentication
      set_flash_message(:notie, :success, kind: name) if is_navigational_format?
    else
      create_new_authorization
    end
 end

  def create_new_authorization
    if @auth.info && @auth.info[:email]
      @user = User.find_for_oauth(@auth)
      if @user
        success_omniauth_login(@user, @auth.provider.capitalize)
      else
        redirect_to new_user_registration_url
      end
    else
      session[:auth] = { uid: @auth.uid, provider: @auth.provider }
      @authorization = Authorization.new(provider: @auth.provider, uid: @auth.uid.to_s)
      render 'authorizations/new'
    end
  end
end
