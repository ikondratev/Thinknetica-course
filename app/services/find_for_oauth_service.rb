class FindForOauthService
  def initialize(auth)
    @auth = auth
  end

  def call
    with_email
  end

  private

  def with_email
    authorization = Authorization.where(provider: @auth.provider, uid: @auth.uid.to_s).first
    return authorization.user if authorization

    User.create_by_email(prepare_params)
   end

  def prepare_params
    {
      email: @auth.info[:email],
      provider: @auth.provider,
      uid: @auth.uid
    }
  end
end
