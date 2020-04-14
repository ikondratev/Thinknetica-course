class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  belongs_to :question
  belongs_to :user

  has_many :files
  has_many :links
  has_many :comments
end
