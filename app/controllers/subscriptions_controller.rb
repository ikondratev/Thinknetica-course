class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @subscription = question.subscriptions.new(user: current_user)

    authorize! :create, @subscription

    question.subscribe(current_user)

    redirect_to question_path(question), notice: 'Subscribed successfully'
  end

  def destroy
    authorize! :destroy, subscription

    question.un_subscribe(current_user)

    redirect_to question_path(question), notice: 'Unsubscribed successfully'
  end

  private

  def question
    Question.find(params[:question_id])
  end

  def subscription
    question.subscriptions.find_by(user: current_user, question: question)
  end
end
