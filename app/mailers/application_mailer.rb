# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'ilyafulleveline@gmail.com'
  layout 'mailer'
end
