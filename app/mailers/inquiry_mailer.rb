class InquiryMailer < ApplicationMailer
  default from: 'notification@flexcoast.com'
  def created_email(inquiry)
    user = 'broker@flexcoast.com'
    mail(to: user, subject: 'New inquiry, 2021-06-21')
  end
end
