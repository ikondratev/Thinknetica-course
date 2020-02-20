class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  helper_method :answer
  helper_method :question

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    flash.now[:notice] = "Your answer have been successfully updated" if current_user.is_author_of?(answer) && answer.update(answer_params)
  end

  def destroy
    if current_user.is_author_of?(answer)
      answer.destroy
      flash.now[:notice] = 'Your answer have been successfully destroyed.'
    end
  end

  def set_the_best
    if current_user.is_author_of?(question)
      answer.set_the_best
      @answers = answer.question.answers.reload
    end
  end

  private

  def publish_answer
    return if answer.errors.any?

    AnswersChannel.broadcast_to(
      answer.question,
      answer: answer,
      email: answer.user.email,
      links: helpers.links(answer.links),
      files: helpers.urls(answer.files)
    )
    end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
