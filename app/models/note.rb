class Note < ApplicationRecord
  validates_presence_of :body

  belongs_to :inquiry
  belongs_to :creator, class_name: 'User', optional: true
end
