class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github facebook twitter]

  has_many :answers
  has_many :questions
  has_many :gifts
  has_many :subscriptions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  validates :email, :password, presence: true

  def is_author_of?(resource)
    id == resource&.user_id
  end

  def is_not_author_of?(resource)
    !is_author_of?(resource)
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.create_by_email(params)
    user = User.where(email: params[:email]).first

    if user
      user.authorizations.create(provider: params[:provider], uid: params[:uid])
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: params[:email], password: password, password_confirmation: password)
      user.authorizations.create(provider: params[:provider], uid: params[:uid])
    end

    user
  end

  def subscribed?(question)
    subscriptions.where(user_id: id, question_id: question.id).present?
  end
end
