class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :order_by_the_best, -> { order the_best: :desc }

  validates :body, presence: true, length: { minimum: 5 }

  def set_the_best
    transaction do
      question.answers.where(the_best: true).update_all(the_best: false)
      update!(the_best: true)
    end
  end
end
