class AuthorizationsController < ApplicationController
  def new; end

  def create
    @email = params[:email].first
    @auth = params[:auth]

    @user = User.find_by(email: @email)

    if @user&.persisted?
      @user.authorizations.create(provider: @auth[:provider], uid: @auth[:uid])
      sign_in_and_redirect @user, event: :authentication
    else
      password = Devise.friendly_token[0, 20]
      token = Devise.friendly_token[0, 12]

      @user = User.create!(email: @email, password: password, password_confirmation: password, confirmation_token: token)
      @user.authorizations.create(provider: @auth[:provider], uid: @auth[:uid])
      @user.save

      AuthMailer.notify_record(email: @email, token: @user.confirmation_token).deliver_now
      binding.pry

      render 'authorizations/confirmation'
    end
  end

  def edit
    @user = User.find_by(confirmation_token: params[:id])

    if @user&.persisted?
      @user.update(confirmed_at: Time.now, email: params[:email])
      sign_in_and_redirect @user, event: :authentication
    else
      render 'authorizations/unconfirmed'
    end
  end
end
