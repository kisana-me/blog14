class Post < ApplicationRecord
  include MdTools

  belongs_to :account
  belongs_to :thumbnail, class_name: "Image", optional: true
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :post_images
  has_many :images, through: :post_images
  has_many :comments
  has_many :view_logs, as: :viewable

  attribute :meta, :json, default: -> { {} }
  enum :visibility, { closed: 0, limited: 1, opened: 2 }
  enum :status, { normal: 0, locked: 1, deleted: 2, specific: 3 }
  attr_accessor :thumbnail_new_image
  attr_accessor :thumbnail_image_aid, :selected_tags

  after_initialize :set_aid, if: :new_record?
  before_validation :set_name_id
  before_validation :assign_thumbnail
  before_save :transform_standard2custom_image
  after_save :sync_post_images, if: :saved_change_to_content?

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
            length: { in: 1..100_000, allow_blank: true }

  scope :from_normal_accounts, -> { joins(:account).where(accounts: { status: :normal }) }
  scope :is_normal, -> { where(status: :normal) }
  scope :isnt_deleted, -> { where.not(status: :deleted) }
  scope :is_opened, -> { where(visibility: :opened) }
  scope :isnt_closed, -> { where.not(visibility: :closed) }

  # === #

  def thumbnail_url
    thumbnail&.image_url || "/img-2.webp"
  end

  def tagging(tags: selected_tags)
    self.tags = tags.blank? ? [] : Tag.where(aid: tags)
  end

  private

  def set_name_id
    self.name_id = aid if name_id.blank?
  end

  def assign_thumbnail
    if thumbnail_new_image.present?
      self.thumbnail = Image.create(
        account: account,
        image: thumbnail_new_image
      )
    elsif thumbnail_image_aid.present?
      self.thumbnail = Image.is_normal.find_by(
        account: account,
        aid: thumbnail_image_aid
      )
    end
  end

  def transform_standard2custom_image
    return if content.blank?

    new_content = standard2custom_image(content)

    if new_content != content
      self.content = new_content
      Rails.logger.info("POST TRANSFORM LEGACY IMAGES IN MARKDOWN ======= TRANSFORMED!!!")
    end
    new_content
  end

  def sync_post_images
    return if content.blank?

    # Find our custom image syntax occurrences: ?[image](...) and extract aids
    aids = content.to_s.scan(/\?\[image\]\(([^)]+)\)/).flat_map do |m|
      raw = m.first.to_s
      raw.split(",").map { |part| part.to_s.split("|", 2).first.to_s.strip }
    end
    aids = aids.filter_map(&:presence).uniq

    return if aids.empty?

    found_images = Image.from_normal_accounts.is_normal.where(aid: aids)

    # Keep only found images and preserve current ordering by aids
    ordered_images = aids.filter_map { |a| found_images.find { |img| img.aid == a } }

    # Replace associations using ActiveRecord collection writer
    self.images = ordered_images
  end
end
