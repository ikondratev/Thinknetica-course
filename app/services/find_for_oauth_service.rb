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

    user = User.create_by_email(prepare_params)
    user
   end

  def without_email
    User.new
  end

  def prepare_params
    {
      email: @email,
      provider: @auth.provider,
      uid: @auth.uid
    }
  end
end
