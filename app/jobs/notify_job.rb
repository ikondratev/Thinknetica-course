class NotifyJob < ApplicationJob
  queue_as :default

  def perform(obj)
  	NotificationAnswerService.new.send_notification(obj)
  end
end