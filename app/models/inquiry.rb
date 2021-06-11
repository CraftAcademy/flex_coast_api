class Inquiry < ApplicationRecord
  include AASM

  aasm column: 'inquiry_status' do
    state :pending, initial: true
    state :started, :done

    event :start do
      transitions from: :pending, to: :started do
        guard do
          self.save
          add_note("This is inquiry was started #{self.updated_at.strftime("%d %b %Y")}")
        end
      end
    end

    event :finish do
      transitions from: :started, to: :done do
        guard do
          self.save
          add_note("This is inquiry was finished #{self.updated_at.strftime("%d %b %Y")}")
        end
      end
    end

    event :set_to_pending do
      transitions from: :started, to: :pending do
        guard do
          self.save
          add_note("This is inquiry was shelved #{self.updated_at.strftime("%d %b %Y")}")
        end
      end
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
  has_many :notes

  private

  def add_note(body)
    if broker && self.notes != []
      self.notes.create(
        body: body,
        creator_id: broker_id
      )   
    else
      self.notes.create(
        body: body
      )
    end
  end

  def send_notifications
    add_note("This is inquiry was submitted #{self.created_at.strftime("%d %b %Y")}")
    NotificationService.new_inquiry(self)
  end
end
