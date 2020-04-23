class DailyReportMailer < ApplicationMailer
  def send_report
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
