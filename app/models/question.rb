class Question < ApplicationRecord
  has_many :answers
  belongs_to :user

  validates :title, :body, presence: true
end
