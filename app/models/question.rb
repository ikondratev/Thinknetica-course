class Question < ApplicationRecord
  include Voteable
  include Commentable

  scope :for_digest, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }

  belongs_to :user

  has_many :answers, -> { order_by_the_best }, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :gift, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :gift, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  after_create :subscription

  def subscribe(author)
    subscriptions.create!(user_id: author.id)
  end

  def un_subscribe(author)
    subscriptions.find_by(user_id: author.id).destroy
  end

  private

  def subscription
    subscriptions.create!(user_id: user.id)
  end

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
