# Preview all emails at http://localhost:3000/rails/mailers/daily_report
class DailyReportPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/daily_report/send_report
  def send_report
    DailyReportMailer.send_report
  end
end
