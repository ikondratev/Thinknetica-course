class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question_new = Question.create(question_params.merge(user: current_resource_owner))
    render json: @question_new
  end

  def update
    @question.update(question_params)
    render json: @question
  end

  def destroy
    render json: Question.delete(@question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
