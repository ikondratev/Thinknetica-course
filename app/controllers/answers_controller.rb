class AnswersController < ApplicationController
  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question
    else
      render :new
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer
  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
