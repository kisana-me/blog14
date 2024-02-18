class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags
  validates :tag_name_id,
    presence: true,
    length: { in: 5..250, allow_blank: true },
    format: { with: BASE_64_URL_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false }
end
