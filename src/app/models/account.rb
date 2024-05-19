class Account < ApplicationRecord
  has_many :sessions
  has_many :posts
  has_many :images
  has_many :comments
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
  validate :icon_type_and_required
  before_create :icon_upload
  before_update :icon_upload
  attr_accessor :icon
  attr_accessor :invitation_code

  def icon_upload
    if icon
      if self.icon_original_key.present?
        delete_variants(variants_column: 'icon_variants', image_type: 'icons')
        s3_delete(key: self.icon_original_key)
      end
        extension = icon.original_filename.split('.').last.downcase
        key = "/icons/#{self.aid}.#{extension}"
        self.icon_original_key = key
        s3_upload(key: key, file: self.icon.tempfile, content_type: self.icon.content_type)
    end
  end
  def icon_url(variant_type: 'icons')
    if self.icon_original_key.present?
      unless self.icon_variants.include?(variant_type)
        process_image(
          variant_type: variant_type,
          image_type: 'icons',
          variants_column: 'icon_variants',
          original_key_column: 'icon_original_key'
        )
      end
      return object_url(key: "/variants/#{variant_type}/icons/#{self.aid}.webp")
    else
      return '/'
    end
  end

  private

  def icon_type_and_required
    varidate_image(column_name: 'icon', required: false)
  end
end
