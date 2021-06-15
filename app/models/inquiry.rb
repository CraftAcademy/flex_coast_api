class Inquiry < ApplicationRecord
  include AASM

  aasm column: 'inquiry_status' do
    state :pending, initial: true
    state :started, :done

    event :start do
      transitions from: :pending, to: :started do
        guard do
          add_note("This is inquiry was started.")
        end
      end
    end

    event :finish do
      transitions from: :started, to: :done do
        guard do
          add_note("This is inquiry was finished.")
        end
      end
    end

    event :set_to_pending do
      transitions from: :started, to: :pending do
        guard do
          add_note("This is inquiry was shelved.")
        end
      end
    end

    event :set_to_started do
      transitions from: :done, to: :started do
        guard do
          add_note("This is inquiry was not actually finished.")
        end
      end
    end

  end

  def aasm_event_failed(event_name, old_state_name)
    raise StandardError, "You can't perform this on an inquiry that is '#{old_state_name}'"
  end

  validates_presence_of :email

  after_create :send_notifications

  enum office_type: { office: 1, open_space: 2, combined: 3 }
  enum inquiry_status: { pending: 1, started: 2, done: 3 }
  enum flexible: { yes: 1, no: 2, mixed: 3 }

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

  def send_notifications
    add_note("This is inquiry was submitted.")
    NotificationService.new_inquiry(self)
  end
end
