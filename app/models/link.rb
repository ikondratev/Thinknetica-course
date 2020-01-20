class Link < ApplicationRecord
  belongs_to :question

  validates :name, :url, presence: true
end
