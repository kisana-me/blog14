class Account < ApplicationRecord
  has_many :sessions
  has_many :posts
  has_many :images
  has_many :comments

  attribute :meta, :json, default: {}
  enum :status, { normal: 0, locked: 1, deleted: 2 }

  attr_accessor :icon

  before_save :icon_save
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
  validate :icon_type_and_required

  default_scope { where(status: :normal) }



  def admin?
    self.meta["roles"]&.include?("admin")
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

  def icon_save
    if icon
      if self.icon_original_key.present?
        delete_variants(variants_column: 'icon_variants', image_type: 'icons')
        s3_delete(key: self.icon_original_key)
      end
        extension = icon.original_filename.split('.').last.downcase
        key = "/icons/#{self.aid}.#{extension}"
        self.icon_original_key = key
        s3_upload(key: key, file: self.icon.path, content_type: self.icon.content_type)
    end
  end

  def icon_type_and_required
    varidate_image(column_name: 'icon', required: false)
  end
end
