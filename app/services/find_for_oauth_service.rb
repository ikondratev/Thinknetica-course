class FindForOauthService
  def initialize(auth)
    @auth = auth
    @email = auth.info[:email]
  end

  def call
    @email.blank? ? without_email : with_email
  end

  private

  def with_email
    authorization = Authorization.where(provider: @auth.provider, uid: @auth.uid.to_s).first
    return authorization.user if authorization

    user = User.where(email: @email).first

    if user
      user.authorizations.create(provider: @auth.provider, uid: @auth.uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: @email, password: password, password_confirmation: password)
      user.authorizations.create(provider: @auth.provider, uid: @auth.uid)
    end

    user
   end

  def without_email
    User.new
  end
end
