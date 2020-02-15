module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def score
    votes.sum(:count)
  end

  def current_vote(user)
    return if user.is_author_of?(self)

    votes.find_by(user: user) || votes.create(user: user)
  end
end
