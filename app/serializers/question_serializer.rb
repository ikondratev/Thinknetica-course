class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :user
  belongs_to :user
  has_many :answers
  has_many :comments
  has_many :links
  has_many :files

  def short_title
    object.title.truncate(5)
  end
end
