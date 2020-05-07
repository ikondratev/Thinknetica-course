class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true, touch: true

  validates :count, presence: true, inclusion: { in: [-1, 0, 1] }
  validate :cannot_revoting

  def like!
    vote!(1)
  end

  def dislike!
    vote!(-1)
  end

  private

  def vote!(count)
    self.count == count ? destroy : update(count: count)
  end

  def cannot_revoting
    errors.add(:user, "can't revoiting") if user&.is_author_of?(voteable)
  end
end
