class InquiryMailer < ApplicationMailer
  default from: 'notification@flexcoast.com'

  def broker_email(data)
    @inquiry = data
    @user = 'broker@flexcoast.com'
    mail(to: @user, subject: "New inquiry, #{@inquiry.created_at.strftime("%d %b %Y")}")
  end

  def en_submitter_email(data)
    inquiry = data
    mail(to: inquiry.email, subject: "Johanna at FlexCost is on top of things!")
  end

  def en_started_email(data)
    @inquiry = data
    mail(to: @inquiry.email, subject: "Johanna at FlexCoast has started to look at offices for you")
  end

  def se_submitter_email(data)
    inquiry = data
    mail(to: inquiry.email, subject: "Johanna på FlexCoast har koll på läget")
  end

  def se_started_email(data)
    @inquiry = data
    mail(to: @inquiry.email, subject: "Johanna på FlexCoast har nu börjat leta efter ett kontor till dig")
  end
end