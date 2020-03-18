class AuthMailer < ActionMailer::Base
  default from: 'ilyafulleveline@gmail.com'

  def notify_record(args)
    @text = args[:text]
    @email = args[:email]
    mail(to: @email, subject: 'TEstststst')
  end
end
