require "slack-notify"

module NotificationService

  def self.new_inquiry(inquiry)
    InquiryMailer.created_email(inquiry).deliver
    client = SlackNotify::Client.new(
      webhook_url: 'https://hooks.slack.com/services/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'
    )
    client.notify("New Inquiry From #{inquiry.company} In Your Inbox", "#flex-coast-final-project-march-2021")
  end
end
