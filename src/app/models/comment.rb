class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :account, optional: true
  belongs_to :comment, optional: true
  has_many :comments
  validates :content,
    presence: true

  #@comment.errors.add(:base, "返信先が見つかりません")
end
