class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.for_digest
    mail to: user.email
  end
end
