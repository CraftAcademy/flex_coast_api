class Inquiry < ApplicationRecord
  include AASM

  aasm :column => 'inquiry_status' do
    state :pending, initial: true
    state :started, :done

    event :start do
      transitions from: :pending, to: :started
    end

    event :finish do
      transitions from: :started, to: :done
    end

    # transitions from: :pending, to: :done, guards: :illegal
    # transitions from: :started, to: :pending, guards: :illegal
    # transitions from: :done, to: :pending, guards: :illegal
    # transitions from: :done, to: :started, guards: :illegal

    def illegal
      false
    end
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
