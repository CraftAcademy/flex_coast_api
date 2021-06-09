class Inquiry < ApplicationRecord
  validates_presence_of :email

  after_create :send_notifications

  enum office_type: { office: 1, open_space: 2 }
  enum inquiry_status: { pending: 1, started: 2, done: 3 }

  private

  def send_notifications
    NotificationService.new_inquiry(self)
  end
end
