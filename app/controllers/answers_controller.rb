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
    if answer.update(answer_params)
      redirect_to question, notice: 'Your answer have been successfully updated.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.is_author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer have been successfully destroyed.'
    else
      flash[:notice] = 'No access to delete.'
    end
    redirect_to question
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
