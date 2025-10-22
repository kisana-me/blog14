class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags

  attribute :meta, :json, default: -> { {} }
  enum :status, { normal: 0, locked: 1, deleted: 2 }

  after_initialize :set_aid, if: :new_record?
  before_validation :set_name_id

  validates :name,
            presence: true,
            length: { in: 1..50, allow_blank: true }
  validates :name_id,
            presence: true,
            length: { in: 1..50, allow_blank: true },
            format: { with: BASE64_URLSAFE_REGEX, allow_blank: true },
            uniqueness: { case_sensitive: false, allow_blank: true }
  validates :description,
            length: { in: 1..5000, allow_blank: true }

  scope :is_normal, -> { where(status: :normal) }
  scope :isnt_deleted, -> { where.not(status: :deleted) }

  # === #

  private

  def set_name_id
    self.name_id = aid if name_id.blank?
  end
end
