class Post < ApplicationRecord
  belongs_to :account
  has_many :post_tags
  has_many :tags, through: :post_tags
  validates :post_name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    uniqueness: { case_sensitive: false }
end
