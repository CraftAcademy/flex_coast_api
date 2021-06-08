class Inquiry < ApplicationRecord
  validates_presence_of :email

  after_create :send_notification_mail

  enum office_type: {office: 1, open_space: 2}
  enum inquiry_status: {pending: 1, started: 2, done: 3}

  private

  def send_notification_mail
    InquiryMailer.created_email(self).deliver
  end
end
