class Account < ApplicationRecord
  has_many :sessions, foreign_key: :account_id
  has_many :account_posts
  has_many :posts, through: :account_posts
  has_many :images, foreign_key: :account_id
  has_secure_password
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
