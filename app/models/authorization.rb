class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  def self.generate(params)
    @params = params

    return if invalid?

    user = User.create_by_email(email: params[:email],
                                provider: params[:provider],
                                uid: params[:uid])

    @auth = Authorization.find_or_create_by(provider: params[:provider],
                                            uid: params[:uid],
                                            user: user)

    @auth.update!(confirmed_at: Time.zone.now)
    @auth
  end

  def self.invalid?
    @params[:provider].blank? || @params[:uid].blank? || @params[:email].blank?
  end
end
