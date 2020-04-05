class AuthMailer < ActionMailer::Base
  default from: 'ilyafulleveline@gmail.com'

  def notify_record(args)
    @token = args[:token]
    @email = args[:email]

    mail(to: @email, subject: 'Registration new User')
  end
end
