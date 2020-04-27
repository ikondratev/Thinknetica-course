class NotificationAnswerService
  def send_notification(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      NotificationAuthorMailer.notify(subscription.user, answer).deliver_later
    end
  end
end
