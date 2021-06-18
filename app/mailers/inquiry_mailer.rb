class InquiryMailer < ApplicationMailer
  default from: 'notification@flexcoast.com'

  def broker_email(data)
    @inquiry = data
    @user = 'broker@flexcoast.com'
    mail(to: @user, subject: "New inquiry, #{@inquiry.created_at.strftime("%d %b %Y")}")
  end

  def submitter_email(data)
    inquiry = data
    mail(to: inquiry.email, subject: "FlexCost is on top of things!")
  end

  def started_email(data)
    @inquiry = data
    mail(to: @inquiry.email, subject: "FlexCoast has started processing your inquiry")
  end
end