class Question < ApplicationRecord
  include Voteable

  belongs_to :user

  has_many :answers, -> { order_by_the_best }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :gift, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :gift, reject_if: :all_blank

  validates :title, :body, presence: true
end
