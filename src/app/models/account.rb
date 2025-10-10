class Account < ApplicationRecord
  has_many :sessions
  has_many :posts
  has_many :images
  has_many :comments
  belongs_to :icon, class_name: "Image", optional: true

  attribute :meta, :json, default: {}
  enum :visibility, { closed: 0, limited: 1, opened: 2 }
  enum :status, { normal: 0, locked: 1, deleted: 2 }
  attr_accessor :icon_aid

  before_validation :assign_icon
  before_create :set_aid

  validates :anyur_id,
    allow_nil: true,
    uniqueness: { case_sensitive: false }
  validates :name,
    presence: true,
    length: { in: 1..50, allow_blank: true }
  validates :name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    format: { with: NAME_ID_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false, allow_blank: true }
  validates :description,
    allow_blank: true,
    length: { in: 1..500 }
  has_secure_password validations: false
  validates :password,
    allow_blank: true,
    length: { in: 8..30 },
    confirmation: true

  scope :is_normal, -> { where(status: :normal) }
  scope :isnt_deleted, -> { where.not(status: :deleted) }
  scope :is_opened, -> { where(visibility: :opened) }
  scope :isnt_closed, -> { where.not(visibility: :closed) }

  # === #

  def icon_url
    self.icon&.image_url(variant_type: "icon") || "/img-1.png"
  end

  def admin?
    self.meta["roles"]&.include?("admin")
  end

  private

  def assign_icon
    return if icon_aid.blank?
    self.icon = Image.find_by(
      account: self,
      aid: icon_aid,
    )
  end
end
