class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]

  helper_method :question

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    gon.question_id = question.id
    gon.user_id = current_user ? current_user.id : 0

    @answer = question.answers.new
    @answer.links.new
  end

  def new
    question.links.new
    question.gift = Gift.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    flash.now[:notice] = "Your question have been successfully updated" if question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: "Your question have been successfully destroyed."
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : current_user.questions.new
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', question: @question)
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[id name url _destroy],
                                                    gift_attributes: %i[name image])
  end
end
