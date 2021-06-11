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

  after_create :send_notifications, :automated_notes
  after_update :automated_notes

  enum office_type: { office: 1, open_space: 2 }
  enum inquiry_status: { pending: 1, started: 2, done: 3 }

  belongs_to :broker, class_name: 'User', optional: true
  has_many :notes

  private

  def send_notifications
    NotificationService.new_inquiry(self)
  end

  def automated_notes
    if inquiry_status == "done" && self.inquiry_status_before_last_save == "started"
      self.notes.create(
        body: "This is inquiry was finished #{self.updated_at.strftime("%d %b %Y")}"
      )
    elsif inquiry_status == "started" && self.inquiry_status_before_last_save == "pending"
      self.notes.create(
        body: "This is inquiry was started #{self.updated_at.strftime("%d %b %Y")}"
      )
    elsif inquiry_status == "pending" && self.inquiry_status_before_last_save == "started"
      self.notes.create(
        body: "This is inquiry was shelved #{self.updated_at.strftime("%d %b %Y")}"
      )
    else
      self.notes.create(
        body: "This is inquiry was submitted #{self.created_at.strftime("%d %b %Y")}"
      )
    end
  end
end
