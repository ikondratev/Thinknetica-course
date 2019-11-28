class User < ApplicationRecord
  has_many :questions
  has_many :answers

  validates :u_name, :u_email, presence: true
end
