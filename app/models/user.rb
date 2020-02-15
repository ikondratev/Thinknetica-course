class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers
  has_many :questions
  has_many :gifts

  validates :email, :password, presence: true

  def is_author_of?(resource)
    id == resource&.user_id
  end

  def is_not_author_of?(resource)
    !is_author_of?(resource)
  end
end
