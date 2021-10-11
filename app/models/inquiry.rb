class Inquiry < ApplicationRecord
  include AASM

  aasm column: 'inquiry_status' do
    state :pending, initial: true
    state :started, :done

    event :start do
      transitions from: :pending, to: :started do
        guard do
          add_note("This inquiry was started.")
          send_started_notification()
        end
      end
    end

    event :finish do
      transitions from: :started, to: :done do
        guard do
          add_note("This inquiry was finished.")
        end
      end
    end

    event :set_to_pending do
      transitions from: :started, to: :pending do
        guard do
          add_note("This inquiry was shelved.")
        end
      end
    end

    event :set_to_started do
      transitions from: :done, to: :started do
        guard do
          add_note("This inquiry was not actually finished.")
        end
      end
    end

  end

  def aasm_event_failed(event_name, old_state_name)
    raise StandardError, "You can't perform this on an inquiry that is '#{old_state_name}'"
  end

  validates_presence_of :email

  after_create :send_notifications

  enum office_type: { office_space: 1, office_room: 2, fixed_space: 3, flexible_space: 4 }
  enum inquiry_status: { pending: 1, started: 2, done: 3 }
  enum flexible: { yes: 1, no: 2, mixed: 3 }
  enum start_date: { now: 1, quarter: 2, unsure: 3 }

  belongs_to :broker, class_name: 'User', optional: true
  has_many :notes

  private

  def add_note(body)
    if self.broker && self.notes != []
      self.notes.create(
        body: body,
        creator: self.broker
      )   
    else
      self.notes.create(
        body: body
      )
    end
  end

  def send_started_notification
    unless self.started_email_sent
      if self.language == 'se'
        InquiryMailer.se_started_email(self).deliver if Rails.env.test?
      else
        InquiryMailer.en_started_email(self).deliver if Rails.env.test?
      end
      self.update(started_email_sent: true)
    end
  end

  def send_notifications
    add_note("This inquiry was submitted.")
    NotificationService.new_inquiry(self)
  end
end
