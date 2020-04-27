class NotificationAuthorMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    @question = Question.find_by(id: answer&.question_id)
    @user = user

    mail(to: @user.email, subject: 'FPS Notification')
  end
end
