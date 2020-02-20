class Answer < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_one :gift, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :order_by_the_best, -> { order the_best: :desc }

  validates :body, presence: true, length: { minimum: 5 }

  def set_the_best
    transaction do
      question.answers.where(the_best: true).update_all(the_best: false)
      reward
      update!(the_best: true)
    end
  end

  private

  def reward
    gift = question.gift
    gift&.update!(answer: self, user: user)
  end
end
