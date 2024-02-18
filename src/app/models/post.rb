class Post < ApplicationRecord
  has_many :account_posts
  has_many :accounts, through: :account_posts
  has_many :post_tags
  has_many :tags, through: :post_tags
  validates :post_name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    format: { with: BASE_64_URL_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false }
end
