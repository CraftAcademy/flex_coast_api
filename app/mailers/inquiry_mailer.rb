class InquiryMailer < ApplicationMailer
  default from: 'notification@flexcoast.com'
  def created_email(data)
    @inquiry = data
    @user = 'broker@flexcoast.com'
    mail(to: @user, subject: "New inquiry, #{@inquiry.start_date}")
  end
end
