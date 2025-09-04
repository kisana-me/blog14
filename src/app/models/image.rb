class Image < ApplicationRecord
  belongs_to :account, optional: true

  attribute :variants, :json, default: []
  attribute :meta, :json, default: {}
  enum :status, { normal: 0, locked: 1, deleted: 2 }
  attr_accessor :image

  after_initialize :set_aid, if: :new_record?
  before_create :image_upload

  validate :image_varidation

  default_scope { where(status: :normal) }

  def image_url(variant_type: "normal")
    if !variants.include?(variant_type) && original_ext.present?
      process_image(variant_type: variant_type)
    end
    return object_url(key: "/images/variants/#{variant_type}/#{self.aid}.webp")
  end

  private

  def image_upload
    self.name = image.original_filename.split(".").first if self.name.blank?
    extension = image.original_filename.split(".").last.downcase
    self.original_ext = extension
    s3_upload(
      key: "/images/originals/#{self.aid}.#{extension}",
      file: self.image.path,
      content_type: self.image.content_type
    )
  end

  def image_varidation
    return unless new_record?
    varidate_image(required: true)
  end
end
