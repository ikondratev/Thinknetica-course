# Preview all emails at http://localhost:3000/rails/mailers/notification_author_mailer
class NotificationAuthorMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notification_author_mailer/notify
  def notify
    NotificationAuthorMailer.notify
  end
end
