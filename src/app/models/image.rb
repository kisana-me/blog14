class Image < ApplicationRecord
  belongs_to :account
  has_one_attached :image
  validates :image_name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    uniqueness: { case_sensitive: false }
end
