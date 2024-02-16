class Session < ApplicationRecord
  belongs_to :account
  validates :session_name_id,
    presence: true,
    length: { in: 5..250, allow_blank: true },
    uniqueness: { case_sensitive: false }
end
