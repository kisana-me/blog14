class Session < ApplicationRecord
  belongs_to :account

  attribute :meta, :json, default: {}
  enum :status, { normal: 0, locked: 1, deleted: 2 }

  before_create :set_aid

  validates :name,
    allow_blank: true,
    length: { in: 1..50 }

  default_scope { where(status: :normal) }
end
