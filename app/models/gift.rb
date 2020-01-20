class Gift < ApplicationRecord
  belongs_to :question, dependent: :destroy
  belongs_to :answer, optional: true
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, :image, presence: true
end
