class Question < ApplicationRecord
  has_many :answers, -> { order_by_the_best }, dependent: :destroy
  belongs_to :user

  has_one_attached :file

  validates :title, :body, presence: true
end
