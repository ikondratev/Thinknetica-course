class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_for question
  end

  private

  def question
    Question.find(params[:id])
  end
end
