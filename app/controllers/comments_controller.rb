class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]

  authorize_resource

  def create
    @commentable = commentable
    @comment = @commentable.comments.new(user: current_user,
                                         body: commentable_params[:body])
    @comment.save
  end

  private

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def commentable
    commentable_klass.find(params[commentable_id_name])
  end

  def commentable_klass
    commentable_id_name.chomp('_id').classify.constantize
  end

  def commentable_id_name
    @commentable_id ||= params.keys.select { |key| key[/.+_id\z/] }.first
  end

  def publish_comment
    return if @comment.errors.any?

    question = @commentable if @commentable.class == Question
    question = @commentable.question if @commentable.class == Answer

    CommentsChannel.broadcast_to(
      question,
      comment: @comment
    )
  end
end
