class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :account, optional: true
  belongs_to :comment, optional: true
  has_many :comments

  attribute :meta, :json, default: -> { {} }
  enum :visibility, { closed: 0, limited: 1, opened: 2 }
  enum :status, { normal: 0, locked: 1, deleted: 2 }

  before_create :set_aid

  validates :content,
            presence: true,
            length: { in: 1..1000, allow_blank: true }

  scope :from_normal_accounts, -> { left_joins(:account).where(accounts: { status: :normal }).or(where(account: nil)) }
  scope :is_normal, -> { where(status: :normal) }
  scope :isnt_deleted, -> { where.not(status: :deleted) }
  scope :is_opened, -> { where(visibility: :opened) }
  scope :isnt_closed, -> { where.not(visibility: :closed) }
end
