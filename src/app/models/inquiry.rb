class Inquiry < ApplicationRecord
  validates :content,
    presence: true
end
