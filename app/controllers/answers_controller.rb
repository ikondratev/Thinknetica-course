class AnswersController < ApplicationController
  before_action :authenticate_user!

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

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
