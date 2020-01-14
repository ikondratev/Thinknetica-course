class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  helper_method :question

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new; end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    redirect_to @question, notice: 'Your question successfully created.' if @question.save
  end

  def update
    flash.now[:notice] = "Your question have been successfully updated" if current_user.is_author_of?(question) && question.update(question_params)
  end

  def destroy
    if current_user.is_author_of?(question)
      question.destroy
      redirect_to questions_path, notice: "Your question have been successfully destroyed."
    else
      redirect_to question, notice: 'No access to delete.'
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : current_user.questions.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
