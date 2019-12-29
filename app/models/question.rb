class Question < ApplicationRecord
  has_many :answers, -> { order_by_the_best }, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true
end
