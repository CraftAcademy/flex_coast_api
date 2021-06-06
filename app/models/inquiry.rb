class Inquiry < ApplicationRecord
  validates_presence_of :email
  enum office_type: {office: 1, open_space: 2}
end
