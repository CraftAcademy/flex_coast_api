class Inquiry < ApplicationRecord
  validates_presence_of :email
  enum variants: {office: 1, open_space: 2}
end
