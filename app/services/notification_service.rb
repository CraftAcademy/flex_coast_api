require 'slack-notify'

module NotificationService
  def self.new_inquiry(inquiry)
    # TODO: Configure mailer on production server
    InquiryMailer.broker_email(inquiry).deliver if Rails.env.test?
    if inquiry.language == 'se'
      InquiryMailer.se_submitter_email(inquiry).deliver if Rails.env.test?
    else
      InquiryMailer.en_submitter_email(inquiry).deliver if Rails.env.test?
    end

    if Rails.env.production? || Rails.env.test?
      client = SlackNotify::Client.new(
        webhook_url: Rails.application.credentials.dig(:slack, :webhook_url)
      )
      client.notify(
        "New Inquiry From #{inquiry.email} In Your Inbox", 
        '#flex-coast-notify'
      )
    end
  end
end
