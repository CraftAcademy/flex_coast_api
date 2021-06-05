class Inquiry < ApplicationRecord
  validates_presence_of :size, :type, :company, :peers, :email, :date, :flexible, :phone
end
