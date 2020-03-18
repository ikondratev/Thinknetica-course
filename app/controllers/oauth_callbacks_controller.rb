class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    get_user_from('Github')
  end

  def facebook
    get_user_from('Facebook')
  end

  def twitter
    get_user_from('Twitter')
    # AuthMailer.notify_record(email: 'kondratevilya@bk.ru', text: 'blablabla').deliver_now
    # render json: request.env['omniauth.auth']
  end

  private

  def get_user_from(name)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notie, :success, kind: name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end
end
