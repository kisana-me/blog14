class Account < ApplicationRecord
  has_many :sessions, foreign_key: :account_id
  has_many :account_posts
  has_many :posts, through: :account_posts
  has_many :images, foreign_key: :account_id
  has_secure_password
  validates :name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
    format: { with: BASE_64_URL_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false }
  validates :password,
    presence: true,
    length: { in: 8..72, allow_blank: true },
    allow_nil: true
  # == icon == #
  validate :icon_type_and_required
  before_create :icon_upload
  before_update :update_icon_upload
  attr_accessor :icon

  def icon_upload
    extension = icon.original_filename.split('.').last.downcase
    key = "/icon/#{self.aid}.#{extension}"
    self.icon_original_key = key
    s3_upload(key: key, file: self.icon.tempfile, content_type: self.icon.content_type)
  end
  def update_icon_upload
    if icon
      if self.icon_original_key.present?
        delete_variants(column_name: 'icon_variants', image_type: 'icons')
        s3_delete(key: self.icon_original_key)
      end
      icon_upload()
    end
  end
  def create_variant
    process_image(
      variant_type: 'icons',
      image_type: 'icons',
      column_name: 'icon_variants',
      original_key: 'icon_original_key'
    )
  end
  def icon_url(variant_type: 'icons')
    if self.icon_original_key.present?
      unless self.icon_variants.include?(variant_type)
        create_variant()
      end
      return object_url(key: "/variants/#{variant_type}/icons/#{self.aid}.webp")
    else
      return '/'
    end
  end

  private

  def icon_type_and_required
    varidate_image(column_name: 'icon')
  end
end
