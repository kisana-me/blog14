class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :account, optional: true
  belongs_to :comment, optional: true
  has_many :comments

  attribute :meta, :json, default: {}
  enum :status, { pending: 0, disallowed: 1, allowed: 2, deleted: 3 }

  validates :content,
    presence: true,
    length: { in: 1..1000, allow_blank: true }

end
