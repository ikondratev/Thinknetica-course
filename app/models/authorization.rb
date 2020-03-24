class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  def self.generate(params)
    user = User.create_by_email(email: params[:email],
                                provider: params[:provider],
                                uid: params[:uid])

    @auth = Authorization.find_or_create_by(provider: params[:provider],
                                            uid: params[:uid],
                                            user: user)

    @auth.update! confirmed_at: Time.zone.now
    @auth
  end
end
