class Inquiry < ApplicationRecord
  include AASM

  aasm column: 'inquiry_status' do
    state :pending, initial: true
    state :started, :done

    event :start do
      transitions from: :pending, to: :started
    end

    event :finish do
      transitions from: :started, to: :done
    end

    event :set_to_pending do
      transitions from: :started, to: :pending
    end
  end

  def aasm_event_failed(event_name, old_state_name)
    raise StandardError, "You can't perform this on an inquiry that is '#{old_state_name}'"
  end

  validates_presence_of :email

  after_create :send_notifications

  enum office_type: { office: 1, open_space: 2 }
  enum inquiry_status: { pending: 1, started: 2, done: 3 }

  belongs_to :broker, class_name: 'User', optional: true

  private

  def send_notifications
    NotificationService.new_inquiry(self)
  end
end
