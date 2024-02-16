class Account < ApplicationRecord
  has_many :sessions
  has_many :posts
  has_many :images
  has_secure_password
  BASE_64_URL_REGEX  = /\A[a-zA-Z0-9_-]*\z/
  validates :name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    format: { with: BASE_64_URL_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false }
  validates :password,
    presence: true,
    length: { in: 8..72, allow_blank: true },
    allow_nil: true
end
