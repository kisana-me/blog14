class Post < ApplicationRecord
  belongs_to :account
  belongs_to :thumbnail, class_name: "Image", optional: true
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :comments

  attribute :meta, :json, default: {}
  enum :status, { draft: 0, unlisted: 1, specific: 2, published: 3, deleted: 4 }
  attr_accessor :thumbnail_aid
  attr_accessor :selected_tags

  after_initialize :set_aid, if: :new_record?
  before_validation :set_name_id
  before_validation :assign_thumbnail

  validates :name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    format: { with: BASE64_URLSAFE_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false, allow_blank: true }
  validates :title,
    presence: true,
    length: { in: 1..200, allow_blank: true }
  validates :summary,
    presence: true,
    length: { in: 1..500, allow_blank: true }
  validates :content,
    presence: true,
    length: { in: 1..100000, allow_blank: true }

  default_scope { where(status: :published) }
  scope :general, -> { unscoped.where.not(status: :deleted) }

  # === #

  def thumbnail_url
    thumbnail&.image_url(variant_type: "thumbnail")
  end

  def tagging(tags: selected_tags)
    if tags.blank?
      self.tags = []
    else
      tmp_tags = []
      tags.each do |aid|
        tag = Tag.find_by(aid: aid)
        tmp_tags << tag
      end
      self.tags = tmp_tags
    end
  end

  private

  def set_name_id
    self.name_id = aid if name_id.blank?
  end

  def assign_thumbnail
    return if thumbnail_aid.blank?
    self.thumbnail = Image.find_by(
      account: self.account,
      aid: thumbnail_aid,
    )
  end
end
