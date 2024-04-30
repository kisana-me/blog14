class Image < ApplicationRecord
  belongs_to :account
  has_many :posts
  # == image == #
  validate :image_type_and_required
  before_create :image_upload
  before_update :update_image_upload
  attr_accessor :image
  
  def image_upload
    extension = image.original_filename.split('.').last.downcase
    key = "/images/#{self.aid}.#{extension}"
    self.original_key = key
    s3_upload(key: key, file: self.image.tempfile, content_type: self.image.content_type)
  end
  def update_image_upload
    if image
      if self.original_key.present?
        delete_variants(column_name: 'variants', image_type: 'images')
        s3_delete(key: self.original_key)
      end
      image_upload()
    end
  end
  def create_variant
    process_image()
  end
  def image_url(variant_type: 'images')
    if self.original_key.present?
      unless self.variants.include?(variant_type)
        create_variant()
      end
      return object_url(key: "/variants/#{variant_type}/images/#{self.aid}.webp")
    else
      return '/'
    end
  end

  private

  def image_type_and_required
    varidate_image()
  end
end
